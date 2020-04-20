<template>
  <v-app :style="{'background-image': !$vuetify.breakpoint.xsOnly?'url()':'url()', 'background-size': '100% 100%'}">
    <core-drawer v-if="!hide" />

    <core-view />

    <core-cta v-if="!hide" />
  </v-app>
</template>

<script>

  export default {
    name: 'App',
    components: {
      CoreCta: () => import('@/components/core/Cta'),
      CoreDrawer: () => import('@/components/core/Drawer'),
      CoreView: () => import('@/components/core/View')
    },
    data () {
      return {
      //
      }
    },
    computed: {
      hide() {
        return !this.isLogged;
      },
      isLogged () {
        return this.$store.state.isLogged;
      }
    }
  }
</script>
