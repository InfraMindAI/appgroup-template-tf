# Template for the application group Terraform repository.

Having infrastructure monorepo for the whole platform works well in its early life stage but usually creates challenges during its growth. To name a few of them, I can mention that TF code becomes harder to read and understand due to its complexity increasing over time, TF releases become slow as a consequence of a large number of resources to manage, teams start to compete for access to the repository heavily, the monorepo is shared between teams with different skill levels and agreed practices. In addition to this, monorepo makes it challenging to release infrastructure in parallel, which is important in the DR scenario, etc. On top of it, such big shared repositories end up in a “dirty” state from time to time. Because of these and other reasons, as well as the increased risk of breaking infrastructure during bad deployment (big “blast radius”), the monorepo is usually split into smaller, relatively isolated pieces of infrastructure (application groups), each of which lives in a separate repository and is managed by a dedicated team.

The directory structure is the following:
- `template_source` directory contains [cookiecutter](https://github.com/cookiecutter/cookiecutter) template for automatic code generation.
- `generated_code` directory is created for your convenience as a demo of the code, which was generated from the template above.

Read more about it [here](https://workingwiththecloud.com/blog/appgroup-template/).
