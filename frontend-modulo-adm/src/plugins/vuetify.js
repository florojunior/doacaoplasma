import Vue from 'vue';
import Vuetify from 'vuetify/lib';

Vue.use(Vuetify);

const vuetify = new Vuetify({
  icons: {
    iconfont: 'mdi',
  },
  theme: {
    themes: {
      light: {
        primary: '#B71C1C',
        secondary: '#B71C1C',
        accent: '#FFA733',
        error: '#ff5722',
        warning: '#ffc107',
        info: '#8bc34a',
        success: '#4caf50',
        textColor:'#FFA733',
        menuColor:'#FFA733',
        titleMenuColor:'#989898'
      }
    },
  }
});

export default vuetify;