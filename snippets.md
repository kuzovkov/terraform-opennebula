#Init terraform

```bash
terraform init
```

#Create groups:
```bash
terraform plan --target="opennebula_group.users" --out deploy_groups

terraform apply "deploy_groups"
```

#Create users:
```bash
terraform plan --target="opennebula_user.user" --out deploy_users

terraform apply "deploy_users"
```

#Destroy users
```bash
terraform plan --target="opennebula_user.user" --out destroy_users --destroy

terraform apply "destroy_users"
```

#Deploy nets
```bash
terraform plan --target="opennebula_virtual_network.priv-net" --out deploy_nets

terraform apply "deploy_nets"
```

#Destroy nets
```bash
terraform plan --target="opennebula_virtual_network.priv-net" --out destroy_nets --destroy

terraform apply "destroy_nets"
```

#Deploy nats (routers)
```bash
terraform plan --target="opennebula_virtual_machine.nat" --out deploy_nat

terraform apply "deploy_nat"
```

#Deploy srv machines
```bash
terraform plan --target="opennebula_virtual_machine.srv" --out deploy_srv

terraform apply "deploy_srv"
```

#Destroy srv machines
```bash
terraform plan --target="opennebula_virtual_machine.srv" --out destroy_srv --destroy

terraform apply "destroy_srv"
```


#Deploy cli machines
```bash
terraform plan --target="opennebula_virtual_machine.cli" --out deploy_cli

terraform apply "deploy_cli"
```

#Destroy cli machines
```bash
terraform plan --target="opennebula_virtual_machine.cli" --out destroy_cli --destroy

terraform apply "destroy_cli"