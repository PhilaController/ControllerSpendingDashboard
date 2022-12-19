<template>
  <div id="app">
    <div v-if="fiscalYear !== null && data !== null">
      <!-- 1. Introduction -->
      <Intro :data="data" :fiscal-year="fiscalYear" />

      <!-- 2. Detailed Look -->
      <DetailedLook :data="data" :fiscal-year="fiscalYear" />
    </div>
    <div v-else class="loader-wrapper"><span class="loader"></span></div>
  </div>
</template>

<script>
import Intro from "@/sections/Intro";
import DetailedLook from "@/sections/DetailedLook";
import { fetchLatestRelease, fetchAWS } from "@/utils";

export default {
  name: "App",
  components: { Intro, DetailedLook },
  data() {
    return { fiscalYear: null, data: null };
  },
  async created() {
    // Get latest fiscal year
    let config = await fetchLatestRelease();
    this.fiscalYear = config.fiscal_year;

    // Get the expenditure data
    this.data = await fetchAWS("controller-expenditures");
  },
};
</script>

<style>
#app {
  overflow-y: hidden !important;
}
.loader-wrapper {
  display: flex;
  justify-content: center;
}
.loader {
  width: 48px;
  height: 48px;
  border: 5px solid #fff;
  border-bottom-color: #2176d2;
  border-radius: 50%;
  display: inline-block;
  box-sizing: border-box;
  animation: rotation 1s linear infinite;
}

@keyframes rotation {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
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

#startOverlay {
  align-items: flex-start !important;
}

.titlebar {
  max-width: 200px;
}

.left-aligned-menu-content {
  left: 0 !important;
}
</style>
