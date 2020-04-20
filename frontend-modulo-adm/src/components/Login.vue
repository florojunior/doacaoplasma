<template>
  <v-app id="inspire">
    <v-content :style="{'background-image': !$vuetify.breakpoint.xsOnly?'url()':'url()', 'background-size': '100% 100%'}">
      <v-container
        class="fill-height"
        fluid
      >
        <v-row
          align="center"
          justify="center"
        >
          <v-col
            cols="12"
            sm="6"
            md="6"
            xl="4"
          >
            <v-card class="elevation-12">
              <v-toolbar
                color="primary"
                dark
                flat
              >
                <v-toolbar-title>Login</v-toolbar-title>
                <v-spacer />
              </v-toolbar>
              <v-card-text>
                <v-form>
                  <v-text-field
                    label="Email"
                    name="email"
                    v-model="user.usuario"
                    prepend-icon="person"
                    type="text"
                  />

                  <v-text-field
                    id="password"
                    label="Senha"
                    name="senha"
                    prepend-icon="lock"
                    type="password"
                    v-model="user.senha"
                  />
                </v-form>
              </v-card-text>
              <v-card-actions>
                <v-spacer />
                <v-btn color="primary" @click="singin(user)">Login</v-btn>
              </v-card-actions>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
    </v-content>
  </v-app>
</template>

<script>
  export default {
    created(){
     this.$store.commit('setLogout');
    },
    props: {
      source: String
    },
    computed:{
        isLogged () {
            return this.$store.state.isLogged;
        }
    },
    data: () => ({
        isLoading: false,
        user: {},
    }),
    methods:{
        singin(user){
            this.isLoading = true;
            this.$http.post('/login',user)
            .then(res => {
                this.isLoading = false;
                localStorage.setItem("token_dpc", res.data.token);
                localStorage.setItem("codigo_usuario", res.data.dadosUsuario.codigoPessoa);
                this.$store.commit('setLoggedIn');
                this.$router.push({name: 'acompanhamento'},{});
            },
            () =>{
                this.isLoading = false;
                alert('Usuário ou senha inválidos!');
            })
        },
    }
  }
</script>
