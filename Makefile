TASKS = build serve

.PHONY: $(TASKS)

$(TASKS):
	export VUE_APP_DATA_MODE=$(mode); yarn run $@ 