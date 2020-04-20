import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
      token:{},
      userData:{},
      isLogged: true,
      perfil:''
  },
  mutations: {
      setToken(state, token){
        state.token = token;
      },
      setUserData(state, user){
        state.userData = user;
      },
      setLoggedInsetToken(state, isLogged){
        state.isLogged = isLogged;
      },
      setPerfilUsuario(state, perfil){
        state.perfil = perfil;
      },
      setLoggedIn(state){
        state.isLogged = true;
      },
      setLogout(state){
        state.isLogged = false;
      }
  },
  getters: {
    getToken: state => {
      return state.token
    },
    getUserData: state => {
      return state.userData
    },
    isLogged: state => {
      return state.isLogged && (localStorage.getItem('token_kanguru') != null)
    },
    getPerfil: state =>{
      return state.userData.perfil;
    }
  },
  actions: {

  }
})
