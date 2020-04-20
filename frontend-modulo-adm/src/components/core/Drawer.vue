<template >
    <div>
        <v-navigation-drawer
            v-model="drawer"
            app
            width="247px"
        >
        <div class="d-flex flex-column justify-between"  style="height: 100%"> 
            <v-list-item style="max-height: 100px">
                <v-list-item-content style="padding:12px 0 0 0">
                    <v-list-item-title class="text-center">
                        <!--<span class="display-1 textColor--text text-center"> <img style="height: 27px;width: 177; padding-top: 2%;" src="../../assets/logo-kanguru.png"></span>  -->
                    <span class="text-center"> 
                        <img style="height: 75px;width: 175px; padding-top: 2%;" src="https://static.wixstatic.com/media/2f060c_0b1b16828b8d4852b1c8c51adb0317ae~mv2.png/v1/fill/w_412,h_239,al_c,lg_1,q_85/2f060c_0b1b16828b8d4852b1c8c51adb0317ae~mv2.webp">
                    </span>
                    
                    </v-list-item-title>
                </v-list-item-content>
            </v-list-item>

            <v-list dense style="flex-grow: 15; flex-basis: auto;" class="d-flex flex-column justify-center ">
                <v-list>
                    <v-list-item class="hvr-item" v-for="itemMenu in menu" v-bind:key="itemMenu.descricao" :href="'#'+itemMenu.path" :disabled="checkPermission(itemMenu.path)?null:''">
                        <v-list-item-action>
                            <v-icon color="primary" class="hvr-icon">{{itemMenu.icon}}</v-icon>
                        </v-list-item-action >
                        <v-list-item-content>
                            <v-list-item-title class="hvr-text">{{itemMenu.descricao}}</v-list-item-title>
                        </v-list-item-content>
                    </v-list-item>
                </v-list>
            </v-list>
            <v-row>
                <v-col cols="12" align-self="center" align="center">
                    <span style="color: rgb(255, 136, 0); font-style: italic"></span>
                </v-col>
            </v-row>
        </div>  
        </v-navigation-drawer>
        <v-app-bar app color="primary" justify="space-between">         
            <v-app-bar-nav-icon color="white" @click.stop="drawer = !drawer"></v-app-bar-nav-icon>
            <v-toolbar-title>
                <v-row>
                    <v-col>                      
                    </v-col>
                </v-row>
            </v-toolbar-title>

            

            <div color="primary" style="flex-grow:1" class="d-flex align-center justify-start">
                <!--<v-tooltip bottom>
                    <template v-slot:activator="{ on }">
                        <v-btn icon color="white" @click="openDialog()" v-on="on">
                            <v-icon>mdi-account-key</v-icon>
                        </v-btn>
                    </template>
                    <span>Alterar Senha</span>
                </v-tooltip>   -->             
            </div>
                     
        </v-app-bar>
        <!-- DIALOG -->
        <v-dialog v-model="dialog" persistent max-height="300px" max-width="400px">
            <v-card>
                <v-card-title>
                    <v-row align="center" align-content="center" justify="center">
                        <v-col cols="12" lg="12" sm="12" style="text-align: center;" align-self="center">
                            <span style="color: #FFA733; justify-content: center; align: center; font-size: 1.4rem; ">Alterar Senha</span>
                        </v-col>
                    </v-row>
                </v-card-title>
                <v-card-text>
                    <v-container>
                    <v-form
                        ref="form"
                        v-model="formValidated"
                        lazy-validation
                    >
                        <v-row>
                          <v-col cols="12">
                            <v-alert type="error" outlined v-if="errorMessage">
                                Erro na senha.
                            </v-alert>
                            <v-alert type="success" outlined v-if="successMessage">
                                Senha alterada com sucesso.
                            </v-alert>
                          </v-col>
                        </v-row>
                        <v-row>
                            <v-col cols="12" sm="12">
                                <v-text-field
                                  label="" 
                                  outlined 
                                  placeholder=" "
                                  v-model="mudarSenha.password"
                                  required
                                  type="password"
                                  color="textColor"
                                >
                                  <template v-slot:label><span class="dialog-span">Nova Senha</span></template>
                                </v-text-field>
                            </v-col>
                            <v-col cols="12" sm="12">
                                <v-text-field
                                  label="" 
                                  outlined 
                                  placeholder=" "
                                  v-model="mudarSenha.confirmPassword"
                                  :rules="confirmPasswordErrors"
                                  required
                                  type="password"
                                  color="textColor"
                                >
                                  <template v-slot:label><span class="dialog-span">Confirmar Nova Senha</span></template>
                                </v-text-field>
                            </v-col>
                        </v-row>
                    </v-form>
                    <v-row>
                        <v-col><v-btn outlined style="width:100%" @click="dialog = false; closeDialog();" elevation="100" color="#707070">Cancelar</v-btn></v-col>
                        <v-col><v-btn style="width:100%; color: white" @click="gerarNovaSenha()" color="#FFA733">Salvar</v-btn></v-col>                    
                    </v-row>
                    </v-container>
                </v-card-text>              
            </v-card>
        </v-dialog>
    </div>
</template>

<script>

//import router from '../../router';
//import mudarSenhaModel from '@/model/mudarSenha';
//import checkpermissions  from '../../plugins/checkpermission'

export default {
    mounted () {
        let self = this
        window.addEventListener('keyup', function (event) {
            if (event.keyCode === 13) {
                self.gerarNovaSenha()
            }
        })
    },
    data: () => ({
        formValidated:{},
        drawer: '',
        isAdministrador: true,
        dialog: false,
        successMessage: false,
        errorMessage: false,
        menu:[
            {
                descricao:'Desenvolver Formulário',
                path:'/formulario',
                icon:'mdi-file-multiple'
            },
            {
                descricao:'Questionario',
                path:'/questionario',
                icon:'mdi-cube-outline'
            },
            {
                descricao:'Perguntas',
                path:'/pergunta',
                icon:'mdi-account-plus'
            },
            {
                descricao:'Parametros',
                path:'/parametro',
                icon:'mdi-clock'
            },
            {
                descricao:'Listar Voluntários',
                path:'/voluntario',
                icon:'mdi-file-multiple'
            },
        ],
        userLogged: {},
        mudarSenha: {},
    }),
    created(){
        this.userLogged = localStorage.getItem("user_name")
    },
    computed: {
        confirmPasswordErrors() {
            const errors = [];
        
            if (this.mudarSenha.password != this.mudarSenha.confirmPassword) {
            errors.push('Valores de senha devem ser iguais!');
            } 
            return errors
        },
        getUserName() {
            return localStorage.getItem("user_name");
        }
    },
    methods: {
        getShifts(){
            this.$http.get('/dashboardshifts/').then(()=>{

            });
        },
        checkPermission(path){
            if(path == '/usuario'){
                //return checkpermissions('check_user_edit');
            }else if(path == '/relatorio'){
                //return checkpermissions('check_report_add');
            }
            return true;
        },
        logout() {
            this.$http.get('/api-logout/').then(()=>{
                localStorage.setItem("token_dpc", null);
                this.$store.commit('setLogout');
                this.$router.push({name: 'login'},{});
            });
        },
        openDialog(mudarSenha) {
            this.successMessage = false;
            this.errorMessage = false;
            if (mudarSenha !== undefined) {
                this.mudarSenha = mudarSenha;
            } else {
                //this.mudarSenha = new mudarSenhaModel();
            }
            this.dialog = true;
        },
        closeDialog(){
            this.$refs.form.reset();
        },
        gerarNovaSenha() {
            if ((this.mudarSenha.password == this.mudarSenha.confirmPassword)) {
                this.mudarSenha.username = localStorage.getItem('username');
                var mudarSenhaFormData = new FormData();
                mudarSenhaFormData.set("username", this.mudarSenha.username);
                mudarSenhaFormData.set("password", this.mudarSenha.password);
                this.$http.post('/api-password-set/', mudarSenhaFormData).then(()=>{
                })
                this.successMessage = true;
                setTimeout(() => { this.dialog = false;}, 1600);
            } else {
                this.errorMessage = true;
            }
        }
    },
}
</script>

<style>

    .hvr-text{
        /* word-break: break-all; */
        /* word-wrap: break-word; */
        white-space: pre-line;
    }

    .hvr-item:hover{
        background-color: #B71C1C;
        color: white !important;
    }

    .hvr-item .hvr-text{
        color: #6A6A6A;
    }

    .hvr-item:hover .hvr-text{
        color: white !important;
        background-color: #B71C1C;
    }

    .hvr-item:hover .hvr-icon{
        color: white !important;
        /* background-color: white; */
    }
    
    .hvr-leave-item{
        max-height: 64px;
        cursor: pointer;
        background-color: #B71C1C;
    }

    .hvr-leave-item:hover{
        background-color: #B71C1C;
        color: white !important;
    }

    .hvr-leave-text{
        color: white !important;
    }

    .hvr-leave-icon{
        color: white !important;
    }

</style>
