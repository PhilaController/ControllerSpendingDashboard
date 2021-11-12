<template>
  <div>
    <div class="detailed-look" v-if="data != null">
      <!-- Header -->
      <h2>Detailed Spending Data</h2>
      <hr class="titlebar" />

      <!-- user chooses use type and fiscal year -->
      <div class="user-buttons">
        <v-row>
          <UserButtons
            :fiscal-years="fiscalYears"
            :default-fiscal-year="defaultFiscalYear"
            @fiscal-year-change="updateFiscalYears"
          />

          <!-- Show the high level summary -->
          <v-col cols="12" md="6" class="mt-3 high-level-summary">
            <div
              v-show="expendituresNumber > 0 && expendituresNumber !== null"
              class="sub-header high-level-summary-header"
            >
              You are viewing data for
              <b>{{ formatNumber(expendituresNumber) }}</b> expenditures,
              totaling <b>{{ formatTotal(expendituresTotal) }}</b
              >.
            </div>
          </v-col>
        </v-row>
      </div>

      <!-- Dashboard -->
      <Dashboard
        ref="Dashboard"
        :data="data"
        :selected-fiscal-years="selectedFiscalYears"
      />
    </div>
  </div>
</template>

<script>
import UserButtons from "./UserButtons.vue";
import Dashboard from "./Dashboard.vue";
import { ascending } from "d3-array";
import { format } from "d3-format";

export default {
  name: "DetailedLook",
  props: ["fiscal_year", "data"],
  components: { Dashboard, UserButtons },
  data() {
    return {
      defaultFiscalYear: this.fiscal_year,
      selectedFiscalYears: null,
      expendituresTotal: null,
      expendituresNumber: null,
    };
  },
  async created() {
    // Set the selected values to the default values
    this.selectedFiscalYears = [this.defaultFiscalYear.toString()];

    // Update totals
    this.updateExpenditureTotals();
  },
  computed: {
    fiscalYears() {
      /* Fiscal years sorted in ascending order */
      if (this.data == null) return [];
      else {
        return [...new Set(this.data.map((d) => d["Fiscal Year"]))].sort(
          ascending
        );
      }
    },
  },

  methods: {
    formatTotal(d) {
      if (d == 0) return "$0";
      let fmtString = `,.0f`;
      let s = `$${format(fmtString)(Math.abs(d))}`;
      if (d < 0) s = "\u2212" + s;
      return s;
    },
    updateExpenditureTotals() {
      this.$nextTick(() => {
        this.expendituresNumber = this.$refs.Dashboard.expendituresNumber;
        this.expendituresTotal = this.$refs.Dashboard.expendituresTotal;
      });
    },
    updateFiscalYears(value) {
      this.selectedFiscalYears = value;
      this.updateExpenditureTotals();
    },
    formatNumber(d) {
      return format(",.0f")(d);
    },
  },
};
</script>



<style>
.detailed-look {
  margin-top: 50px;
}

.sub-header {
  font-size: 1.25rem;
  font-family: Montserrat, sans-serif;
  line-height: 1.1;
  color: inherit;
  margin-top: 0;
  margin-bottom: 1rem;
}

.admin-note {
  font-style: italic;
  font-size: 1rem;
}
</style>