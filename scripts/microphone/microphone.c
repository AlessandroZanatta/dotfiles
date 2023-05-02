#include <alsa/asoundlib.h>
#include <limits.h>

static char card[] = "default";
static char command[PATH_MAX];
static char script[] = ".sh";

// Handle errors nicely (ty amixer source code)
static void error(const char *fmt, ...) {
  va_list va;

  va_start(va, fmt);
  vfprintf(stderr, fmt, va);
  fprintf(stderr, "\n");
  va_end(va);
}

// Simple utility to get a device name from a snd_hctl_elem_t struct
static const char *get_dev_name(snd_hctl_elem_t *helem) {
  snd_ctl_elem_id_t *id;
  snd_ctl_elem_id_alloca(&id);
  snd_hctl_elem_get_id(helem, id);

  const char *device_name = snd_ctl_elem_id_get_name(id);
  return device_name;
}

static int element_callback(__attribute__((unused)) snd_hctl_elem_t *elem,
                            unsigned int mask) {

  // Whenever the value changes, call the function to handle its change
  if (mask & SND_CTL_EVENT_MASK_VALUE)
    // For simplicity (and because ALSA documentation is like unicorns, it
    // doesn't exist), just use a script to handle printing for polybar
    system(command);
  return 0;
}

static int register_events_cb(__attribute__((unused)) snd_hctl_t *ctl,
                              unsigned int mask, snd_hctl_elem_t *elem) {

  // When adding callbacks to events
  if (mask & SND_CTL_EVENT_MASK_ADD) {
    const char *device_name = get_dev_name(elem);
    size_t len = strlen(device_name);

    // If the device name is either Capture Switch or Capture Volume
    if (!strncmp(device_name, "Capture Switch", len) ||
        !strncmp(device_name, "Capture Volume", len)) {
      fprintf(stderr, "Added: %s\n", device_name);

      // Add a callback (we do not care about other devices)
      snd_hctl_elem_set_callback(elem, element_callback);
    }
  }
  return 0;
}

static int subscribe() {
  snd_hctl_t *handle;
  int err;

  // Open an handle
  if ((err = snd_hctl_open(&handle, card, 0)) < 0) {
    error("Control %s open error: %s\n", card, snd_strerror(err));
    exit(EXIT_FAILURE);
  }

  // Set the callback
  snd_hctl_set_callback(handle, register_events_cb);
  if ((err = snd_hctl_load(handle)) < 0) {
    error("Control %s hbuild error: %s\n", card, snd_strerror(err));
    exit(EXIT_FAILURE);
  }

  // Start event cycle
  while (1) {

    // Whenever an event comes, handle it with the callbacks
    int res = snd_hctl_wait(handle, -1);
    if (res >= 0) {
      fprintf(stderr, "Poll ok: %i\n", res);
      res = snd_hctl_handle_events(handle);
      assert(res > 0);
    }
  }
  snd_hctl_close(handle);
  return 0;
}

int main() {
  // Get directory of script
  if (readlink("/proc/self/exe", command, sizeof(command) - sizeof(script)) <
      0) {
    error("Could not get directory of program!");
    exit(EXIT_FAILURE);
  }

  // Assumes that this file is compiled as "microphone" and that the script
  // you want to execute on change is called "microphone.sh", and both are in
  // the same directory
  strcat(command, ".sh");
  subscribe();
}
