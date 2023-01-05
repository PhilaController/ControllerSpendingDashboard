<template>
  <div>
    <!-- Date Range -->
    <div class="mb-4">
      <p>
        <span class="font-weight-bold">Data Range:</span> January 1, 2018
        through June 30, {{ fiscalYear }}
      </p>
    </div>

    <div id="intro-1">
      <p>
        In the spirit of fiscal transparency, the Controller's Office has
        committed to releasing its expenditures annually, including for
        download. The expenditure data below provides information about spending
        amounts, categories, and vendors for the most recent fiscal year,
        ranging from July 1, {{ fiscalYear - 1 }} to June 30, {{ fiscalYear }},
        by default. Earlier data can be viewed by using the buttons to select
        the desired fiscal year.
      </p>
    </div>

    <!-- the notes section -->
    <div id="intro-2">
      <h2 id="key-takeaways">Quick Facts</h2>
      <hr class="titlebar" />
      <ul aria-labelledby="key-takeaways">
        <li>
          The Controller’s Office uses two major funds, the General Fund and the
          Grants Fund, for its expenditures.
        </li>
        <li>
          About {{ (100 * generalFundPercent).toFixed(0) }}% of expenditures are
          paid from the General Fund, the principal operating fund for the City
          of Philadelphia.
        </li>
        <li>
          The remaining spending comes from the Grants Fund. This spending is
          supported by the School District of Philadelphia, which reimburses the
          Controller’s Office for the Audit Division’s performance of the School
          District Single Audit.
        </li>
        <li>
          Expenditures in the Controller's Office are categorized into 4 major
          classes and more than 30 minor classes. The major class provides a
          broad description of the spending, e.g., payroll, while the minor
          classes give a more detailed description. For clarity, this data
          release groups the Materials/Supplies and Equipment classes into a
          single category since funds can be moved within these classes.
        </li>
        <li>
          The single largest expense for the Controller’s Office is the payroll
          for permanent, full-time employees, representing about
          {{ (100 * fullTimePayrollPercent).toFixed(0) }}% of the total
          spending.
        </li>
        <li>
          Spending internal to the Controller's Office is listed below with a
          vendor of "City Controller's Office". This spending is primarily
          composed of membership dues, transportation reimbursements, media
          subscriptions, and conference registrations.
        </li>
        <li>
          Adjustments to the payroll are categorized as “gross adjustments” and
          can occur for a variety of reasons. Most commonly in the Controller’s
          Office, gross adjustments are for out-of-class work assignments within
          the Civil Service Regulations. However, in FY18 Q4 and FY19 Q1 gross
          adjustments also reflect retroactive pay compensation for District
          Council #47/Non-Rep and Exempt employees.
        </li>
        <li>
          Payroll payments received by employees who leave the Controller’s
          Office are categorized as “lump sum payments.”
        </li>
        <li>
          Negative payroll expenditures can sometimes occur. For example, a
          payroll check for $692.97 was issued in error on 8/6/2018. To correct
          this error, a corresponding expenditure worth $-692.97 was recorded on
          8/10/2018.
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import { sum, rollup } from "d3-array";

export default {
  name: "Intro",
  props: ["data", "fiscalYear"],
  computed: {
    totalSpending() {
      return sum(this.data, (d) => +d["Amount"]);
    },
    dataByFund() {
      return rollup(
        this.data,
        (v) => sum(v, (d) => +d["Amount"]),
        (d) => d["Fund"]
      );
    },
    generalFundPercent() {
      return this.dataByFund.get("General Fund") / this.totalSpending;
    },
    fullTimePayrollPercent() {
      return (
        sum(
          this.data.filter(
            (d) => d["Minor Class Description"] === "Permanent, Full-time"
          ),
          (d) => +d["Amount"]
        ) / this.totalSpending
      );
    },
  },
};
</script>

<style>
#intro-2 li {
  margin-bottom: 0.5rem;
}

#key-takeaways {
  margin-top: 2rem !important;
}
</style>
