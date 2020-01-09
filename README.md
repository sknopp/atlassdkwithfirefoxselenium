based on linkyards [docker-atlassian-plugin-sdk](https://hub.docker.com/r/linkyard/docker-atlassian-plugin-sdk/)

# Usage

Switch into your project home directory and run the following command:

```bash
docker run --rm -P --mount type=bind,source="$(pwd)",target=/app --mount source=atlasmvncache,target=/root/.m2/repository sknopp94/atlassdkwithfirefoxselenium <maven-command>
```
**short explanation**
 * The containers can be used once only. So use the `--rm` flag! 
 * maybe we want to access our Atlassian instance, so we expose the therefore needed ports (`-P`) 
 * The first `--mount` is binding your project directory
 * The second `--mount` creates/binds the cache volume for maven repo files
 * `<maven-command>` could be set to `integration-test`, `package`, `run`, `debug` for example. \
The parameters are directly given to Atlassians `atlas-mvn` cli-tool ([see here for details](https://developer.atlassian.com/server/framework/atlassian-sdk/atlas-mvn/) and enjoy their documentation skills 😉).
