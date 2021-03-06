based on linkyards [docker-atlassian-plugin-sdk](https://hub.docker.com/r/linkyard/docker-atlassian-plugin-sdk/)

Also have a look on the [corresponding Docker Hub page](https://hub.docker.com/r/sknopp94/atlassdkwithfirefoxselenium) for this image.

# Plugin Preparation _(required!)_

You must add a property in your plugins `pom.xml` as follows so this image can work:

```xml
<project>
	<!-- ... -->
	<properties>
		<!-- ... -->
		<buildDirectory>${project.basedir}/target</buildDirectory>
	</properties>
	<!-- ... -->
	<build>
		<directory>${buildDirectory}</directory>
		<!-- ... -->
	</build>
</project>
```

# Usage

Switch into your project home directory and run the following command:

```bash
docker run -it --rm -p 6990:6990 --stop-timeout 60 --name atlassdk --mount type=bind,source="$(pwd)",target=/app --mount source=atlasmvncache,target=/root/.m2/repository sknopp94/atlassdkwithfirefoxselenium <atlas-tool-suffix> <atlas-tool-parameters>
```

**short explanation**
 * For interaction as one is used to in native execution we need the pseudo tty
 * The containers can be used once only. So use the `--rm` flag! 
 * maybe we want to access our Atlassian instance, so we expose the therefore needed ports (`-p`). Use the correct port numbers for your Atlassian product (6990 here for Bamboo)
 * `--stop-timeout 60` after the container is stopped it still needs some time for shutting down Atlassian and copying back the /target-directory to the host system. If you are debugging FileNotFoundExceptions from Atlassian try to increase this value.
 * `--name atlassdk` set a fixed container name for easier reusage of docker commands
 * The first `--mount` is binding your project directory
 * The second `--mount` creates/binds the cache volume for maven repo files
 * `<atlas-tool-suffix>` could be set to `package`, `run`, `debug` for example. \
This would start the corresponding atlassian cli-tool `atlas-package`, `atlas-run`, `atlas-debug` with parameters `<atlas-tool-parameters>` ([see here for details](https://developer.atlassian.com/server/framework/atlassian-sdk/atlas-mvn/) and enjoy their documentation skills 😉).

# How it works

Because Docker does not work performant enough on the root file system directly (at least on macOS), this image needs to move the target directory to an internal path. (You'll find it in containers under `/tmp/target/`). After the build has finished the target-folder is copied back to the host-system for enabling further investigations and reusage.

# Known limitations

 * Unfortunately the image is not useful during active development, because Atlassians file change detection doesn't work, neither in your source-directory nor in the target-dir. Once started, the only way to update your plugin is a full restart. (tested on macOS 10.15.2 with Docker 2.2.0.0)
