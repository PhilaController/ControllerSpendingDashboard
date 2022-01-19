<template>
  <div data-vuetify>
    <!-- Overlay a lodader -->
    <v-overlay
      :value="fiscal_year == null"
      id="startOverlay"
      absolute
      opacity="1"
      color="#fff"
    >
      <v-progress-circular
        class="mt-5"
        indeterminate
        size="64"
        color="#2176d2"
      />
    </v-overlay>

    <v-app id="app">
      <v-main v-if="data !== null">
        <!-- 1. Introduction -->
        <Intro :fiscal_year="fiscal_year" :data="data" />

        <!-- 2. Detailed Look -->
        <DetailedLook :fiscal_year="fiscal_year" :data="data" />
      </v-main>
    </v-app>
  </div>
</template>

<script>
import Intro from "@/components/Intro";
import DetailedLook from "@/components/DetailedLook";
import { fetchLatestRelease, fetchAWS } from "@/utils";

export default {
  name: "App",
  components: { Intro, DetailedLook },
  data() {
    return { fiscal_year: null, data: null };
  },
  async created() {
    // Get latest fiscal year
    let config = await fetchLatestRelease();
    this.fiscal_year = config.fiscal_year;

    // Get the expenditure data
    this.data = await fetchAWS("controller-expenditures");
  },
};
</script>

<style>
#app {
  overflow-y: hidden !important;
}
/* Shared styles */
.card-footer {
  font-size: 14px;
  font-style: italic;
}
#app p {
  margin-bottom: 1rem;
}

#app h2 {
  margin-bottom: 0.5rem;
  margin-top: 1rem;
}

#app h3 {
  padding: 1rem;
}
.card-footer {
  padding: 0.5rem;
}

.v-menu__content {
  left: 0px !important;
}
#startOverlay {
  align-items: flex-start !important;
}

.titlebar {
  max-width: 200px;
}
</style>