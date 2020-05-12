# Kubernetes application upgrade synchronization with Helm

Some applications have upgrade requirements that aren't as simple as a restart. In the Kubernetes world, upgrading an application usually looks like just terminating the current set of pods and standing up the new pods with the updated bits. But there are times when we can't just blindly terminate current pods: Perhaps there is a unit of work that should be cleanly completed before the pod can stop.

For Kubernetes applications that are managed by Helm, we can accomplish this upgrade synchronization through the usage of hooks.

## Sample application

This repo includes a sammple application that can demonstrate this complex upgrade behavior that can be orchestrated with Helm. Without the existence of `./app-chart/templates/pre-upgrade-job.yaml` (which is a `pre-upgrade` hook), there would be no logic considering ongoing operations. In the case of this (very simple) demo application, if the pod (`app`) was to be in the middle of a "long operation" (in this case, if it received a POST on `/start`), there would be a pre-upgrade hook (job) that would be waiting until the operation completed to exit, which would in turn allow the upgrade to continue.

### Observations

Making a code change to the application (`./app`) would then allow a new build to happen (`./build_and_push.sh`).

Simulate a "long-running" operation on the current application pod by running `curl -X POST http://<svc_ip>`. Next, executing `./install_or_upgrade.sh` would show the Helm pre-upgrade hook job (`kubectl logs <pre-upgrade_hook_pod>`) waiting until the operation is complete (which is data that is provided from the API in the `/upgradeable` endpoint).

Once the API says that it is upgradeable, the pre-upgrade hook will successfully complete and exit, allowing the rest of the upgrade to complete, which would include the termination of the old application pod and the creation of the new application pod.

## But why not...

 * ... changing graceful shutdown period? This definitely could be a great solution in many scenarios, but this is a relatively inflexible approach as it isn't as dynamic or flexible. For instance, if we changed the graceful shutdown period to 5 minutes, but a pod's operation could take 5 seconds, 5 minutes, or 5 hours then we wouldn't be able to easily circumvent the SIGKILL when the graceful period shutdown elapses. Not to mention, this would most likely require a code change to handle signals to handle them properly. **This is a good solution if your code handles a SIGTERM to finish up work for a clean shutdown.**
 * ... using a `PreStop` container hook? Much like the graceful shutdown period solution above, it doesn't likely have the flexibility. The duration isn't dynamic in nature, and this is more designed for short-term tasks that may need to be completed prior to a clean shutdown. **This is a good solution if your application has a relatively quick process that can run some cleanup prior to pod termination.**

 Another reason why I like this approach to upgrades is that it is a natural way to handle the upgrade itself, through Helm which is the manager of your Kubernetes application releases. This is where this level of orchestration should be living.

## Considerations

 * Use `helm upgrade --no-hooks` to bypass any hooks in the event of an emergency.
 * Ensure that the `--timeout` for `helm upgrade` is appropriately set to avoid undesired timeouts (it defaults to 5 minutes).
