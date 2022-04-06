Install:
-------------
```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```

Links:
----------
https://www.terraform.io/downloads
https://learn.hashicorp.com/tutorials/terraform/docker-build?in=terraform/docker-get-started
https://registry.terraform.io/providers/OpenNebula/opennebula/latest/docs
https://docs.opennebula.io/6.2/management_and_operations/references/template.html#context-section
