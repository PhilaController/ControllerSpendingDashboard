<template>
  <v-col cols="12" md="6" class="mt-3">
    <div class="btn-group d-flex flex-column">
      <!-- Fiscal Year button -->
      <v-select
        v-model="selectedFiscalYears"
        :items="fiscalYears"
        class="fiscal-year-dropdown w-100 mt-2"
        label="Fiscal Years(s)"
        multiple
        outlined
        dense
        hide-details
        :ripple="false"
        @input="changeSelectedFiscalYears"
        :menu-props="{ contentClass: 'left-aligned-menu-content' }"
      />
    </div>
  </v-col>
</template>

<script>
export default {
  name: "UserButtons",
  props: {
    fiscalYears: { type: Array, default: null },
    defaultFiscalYear: { type: Number, default: null },
  },
  data() {
    return {
      selectedFiscalYears: [this.defaultFiscalYear.toString()],
    };
  },
  methods: {
    changeSelectedFiscalYears(value) {
      this.$emit("fiscal-year-change", this.selectedFiscalYears);
    },
  },
};
</script>

<style>
/* Fiscal year Dropdown */
.fiscal-year-dropdown {
  font-size: 1.2rem !important;
  max-width: 350px !important;
}

.v-list-item__title {
  font-size: 1.2rem !important;
}
</style>