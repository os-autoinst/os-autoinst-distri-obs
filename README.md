openQA tests for Open Build Service Appliances
==============================================

Currently we test:

- [Unstable](https://build.opensuse.org/project/show/OBS:Server:Unstable)
- [2.10:Staging](https://build.opensuse.org/project/show/OBS:Server:2.10:Staging)
- [2.9:Staging](https://build.opensuse.org/project/show/OBS:Server:2.9:Staging)

The test consists basically on booting the appliance and running an [RSpec smoketest](https://github.com/openSUSE/open-build-service/tree/master/dist/t/spec).
Every new appliance gets tested on the [openSUSE reference installation](https://openqa.opensuse.org/parent_group_overview/7).
