<template>
  <v-data-table
    :headers="headers"
    :items="groupedData"
    sort-by="value"
    :sort-desc="true"
    :disable-pagination="disablePagination"
    :hide-default-footer="true"
    mobile-breakpoint="0"
    must-sort
    class="grouped-data-table"
    :page.sync="page"
    :items-per-page="itemsPerPage"
    @page-count="pageCount = $event"
  >
    <template #item.value="{ item }">
      <span>{{ formatTotal(item.value) }}</span>
    </template>

    <template #footer="{ props }" v-if="groupedData.length > itemsPerPage">
      <div class="text-center pt-2 pb-2">
        <h4 id="pagination">Table Pagination</h4>
        <v-pagination
          v-model="page"
          :length="pageCount"
          :total-visible="6"
          aria-labelledby="pagination"
          color="#2176d2"
        />
      </div>
    </template>
  </v-data-table>
</template>

<script>
import { rollup, sum } from "d3-array";
import { format } from "d3-format";

export default {
  props: {
    data: { type: Array, default: null },
    groupby: { type: String, default: null },
  },
  data() {
    return { page: 1, pageCount: 0, itemsPerPage: 15 };
  },
  computed: {
    disablePagination() {
      return this.groupedData.length <= this.itemsPerPage;
    },
    headers() {
      return [
        {
          text: this.groupby,
          align: "start",
          sortable: false,
          value: "name",
        },
        { text: "Amount", value: "value", align: "right", sortable: false },
      ];
    },
    groupedData() {
      let data = rollup(
        this.data,
        (v) => sum(v, (d) => +d["Amount"]),
        (d) => d[this.groupby]
      );

      return Array.from(data, ([name, value]) => ({ name, value })).filter(
        (d) => d["name"] !== ""
      );
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
  },
};
</script>

<style>
.grouped-data-table thead th,
.grouped-data-table tbody td {
  font-size: 1rem !important;
}
.grouped-data-table .v-data-footer,
.grouped-data-table .v-select__selection {
  font-size: 0.9rem !important;
}
</style>