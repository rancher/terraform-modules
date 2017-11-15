MODULE := $(shell basename $$PWD)
TIMESTAMP := $(shell date +%Y-%m-%d-%H%M%S)

.PHONY: get plan plan-destroy plan-output apply

state-pull:
	@terraform remote pull

get:
	@terraform init

plan: get
	@terraform plan -var-file ../main-vars.tfvars -var-file ./$(MODULE).tfvars

plan-output: get
	@terraform plan -var-file ../main-vars.tfvars -var-file ./$(MODULE).tfvars -out $(MODULE)-$(TIMESTAMP).plan

plan-destroy: get
	@terraform plan -var-file ../main-vars.tfvars -var-file ./$(MODULE).tfvars -destroy

apply: get
	@terraform apply -var-file ../main-vars.tfvars -var-file ./$(MODULE).tfvars

apply-plan:
	@terraform apply $(PLAN)

clean:
	@rm *.plan
