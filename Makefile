greet:=hello

KEY_FILE := auth.json
echo:
	@ echo ${greet}

PROJECT_ID:=playground-s-11-2546854d
gcloud_login:
	@ gcloud auth activate-service-account --key-file=${KEY_FILE}

gcloud_set:
	@ gcloud config set project ${PROJECT_ID}

gcloud_list_network:
	@ gcloud compute networks list

VPC:=vpc-api
SUBNET_MODE := custom
gcloud_create_vpc:
	@ gcloud compute networks create ${VPC} --subnet-mode=${SUBNET_MODE}

gcloud_describe_network:
	@ gcloud compute networks describe ${VPC}

REGION:= us-east1
SUBNET:=web
SUBNET_CIDR:= 10.10.0.0/16
ZONE:=us-east1-c
MACHINE_TYPE:=e2-standard-2

gcloud_create_subnet:
	@ gcloud compute networks subnets create ${SUBNET} \
   					--network ${VPC} \
   					--region ${REGION} \
   					--range ${SUBNET_CIDR}
	
gcloud_list_subnet:
	@ gcloud compute networks subnets list

INSTANCE_NAME:=loadbalancer-1
gcloud_create_vm:
	@ gcloud compute instances create ${INSTANCE_NAME} \ 
		--project=${PROJECT_ID} --zone=${ZONE} \
		--machine-type=${MACHINE_TYPE} --subnet=${SUBNET} \
		--image-family=debian-10 --image-project=debian-cloud 
		--boot-disk-size=10GB
		--tag=
		--metadata ssh-keys=root:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCdbozhve5yGM+qIfawYNwlOqvk/g6aIQCedUA7Kgf7/WnvRJ8onX7wuffmFJiRyCPh0EtcGN7NSXL3Nk1Umecd36pjF9w6rR8bQyjymG4b9TgoUHWOhKz7GvnK9KO3Q0SbWVY/OLkfMFgnZsDD+L5sBHALM80CcR7A1QyU6QkfpnDyI2xzwOoKLWcr6zEE4oGiQLlyFU0IsrVZPnHz0C1WphS/onhmCv75hRVf+XUKqRf9HIagGJ9jLU3K8MSZcLh6SeUpoGVo8kdR/zfvZ06fkjTm6HgVV5hJtTuIXfhPjMsMRqU4464wCrQkvhtIZMllubtYz8JzS7dpI1U5KVQLl9PTzdc9ImccIU8sxehO54grC4AjZlTusVedpl715qDpPK0PJoGvwXQ28aHvHToI5ZIkrPqWOQv8wh0LvIAgnvwfBd+fkWpLlYrRaacW7uKCnMzuf5lMNic1ZdSppFdfy2+M1WFC318nCjg9DGG1ir3fPUe39P77OvB2pypgoo8= root@a2c3e9dc083b

gcloud_add_ssh_key:
	@ gcloud compute os-login ssh-keys add --key-file=/root/.ssh/id_rsa.pub --project=${PROJECT_ID}

FIREWALL_RULE_NAME := allow-ssh
create_firewall_rule:
	@ gcloud compute firewall-rules create $(FIREWALL_RULE_NAME) --allow tcp:22 --project $(PROJECT_ID)


gcloud_vm_list:
	@ gcloud compute instances list

gcloud_vm_iap:
	@ gcloud compute ssh ${INSTANCE_NAME} --tunnel-through-iap --zone ${ZONE}

gcloud_vm_ssh:
	@ gcloud compute ssh $(INSTANCE_NAME) --project $(PROJECT_ID) --zone $(ZONE)

# INSTANCE_NAME:=loadbalancer
# delete_vm:
# 	@ gcloud compute instances delete $(INSTANCE_NAME) --project=$(PROJECT_ID) --zone=$(ZONE) --quiet
# all: gcloud_login gcloud_set gcloud_create_vpc gcloud_create_subnet gcloud_create_vm