<template>
    <v-container>
        <v-row class="d-flex justify-center">
            <v-col cols="12" xs="12" sm="12" md="8" lg="6" xl="6">
                <v-card>
                    <v-card-title>
                        <v-row class="d-flex justify-center">
                            <v-col cols="9" class="d-flex justify-start">
                                <p class="title">
                                    Dados Pessoais
                                </p>
                            </v-col>
                            <v-col cols="3"  class="d-flex justify-end">
                                <v-btn @click="redirect()" color="green" large :loading="loading" outlined>Login</v-btn>
                            </v-col>
                        </v-row>
                    </v-card-title>
                    <v-card-text>
                        <v-form
                            ref="form"
                            v-model="formValidated"
                            lazy-validation
                        >
                            <v-row>
                                <v-col cols="12" sm="12" md="12">
                                    <v-text-field
                                        label="Nome"
                                        placeholder="Digite seu nome"
                                        outlined
                                        v-model="usuario.nome"
                                    ></v-text-field>
                                </v-col>
                            </v-row>
                            <v-row>
                                <v-col cols="12" sm="12" md="12">
                                    <v-text-field
                                        label="Data de Nascimento"
                                        placeholder="Data de Nascimento"
                                        outlined
                                        v-mask="'##/##/####'"
                                        v-model="usuario.dataNascimento"
                                    ></v-text-field>
                                </v-col>
                            </v-row>
                            <v-row>
                                <v-col cols="12" sm="12" md="12">
                                    <v-text-field
                                        label="E-mail"
                                        placeholder="Digite seu email"
                                        outlined
                                        v-model="usuario.email  "
                                    ></v-text-field>
                                </v-col>
                            </v-row>
                            <v-row>
                                <v-col sm="6">
                                    <v-text-field
                                    outlined
                                    placeholder=" "
                                    :append-icon="show ? 'mdi-eye' : 'mdi-eye-off'"
                                    :type="show ? 'text' : 'password'"
                                    label=""
                                    required
                                    color="textColor"
                                    class="input-group--focused"
                                    @click:append="show = !show" :rules="requiredRule" 
                                    v-model="usuario.senha" 
                                    >
                                    <template v-slot:label><span class="dialog-span">Senha</span></template>
                                    </v-text-field>
                                </v-col>           
                                <v-col sm="6">
                                    <v-text-field 
                                        outlined 
                                        placeholder=" " 
                                        :append-icon="show1 ? 'mdi-eye' : 'mdi-eye-off'"
                                        :type="show1 ? 'text' : 'password'"
                                        label=""
                                        required 
                                        color="textColor"
                                        class="input-group--focused"
                                        @click:append="show1 = !show1" :rules="confirmPasswordErrors && requiredRule" 
                                        :error-messages="confirmPasswordErrors" 
                                        v-model="usuario.confirma_senha" 
                                        >
                                        <template v-slot:label><span class="dialog-span">Confirma Senha</span></template>
                                    </v-text-field>
                                </v-col>
                            </v-row>
                            <v-row>
                                <v-col>
                                    <v-btn style="width:100%" color="primary" text @click="save()" large :loading="loading" outlined>Cadastre-se</v-btn>
                                </v-col>
                            </v-row>  
                        </v-form>  
                    </v-card-text>
                </v-card>
            </v-col>
        </v-row>
    </v-container>
</template>
<script>
export default {
    created: function(){
        this.$store.commit('setLogout');
    },
    data: () => ({
        formValidated:'',
        loading: false,
        show: false,
        show1: false,
        usuario: {},
        requiredRule: [
            v => (!!v) || 'Campo é requirido'
        ],
        confirm_user_password: ''
    }),
    computed:{
        confirmPasswordErrors() {

            const errors = [];
            if (this.usuario.senha != this.usuario.confirma_senha) {
                errors.push('Valores de senha devem ser iguais!');
            } 
            return errors;

        },
    },
    methods:{
        save(){
             if(this.$refs.form.validate()){
                                  
                 var usuario = {};
                 usuario.nome = this.usuario.nome;
                 usuario.dataNascimento = this.castDataNascimento(this.usuario.dataNascimento);
                 usuario.email = this.usuario.email;
                 usuario.senha = this.usuario.senha;
                 this.loading = true;
                 this.$http.post("/pessoa", usuario)
                 .then((res)=>{
                     localStorage.setItem("token_dpc",res.data.token);
                     localStorage.setItem("codigo_usuario",res.data.codigoPessoa);
                     this.$router.push({name: 'questionario'},{});
                     this.$store.commit('setLoggedIn');
                 }).catch(()=>{
                 }).finally(()=>{
                     this.loading = false;
                 })

             }
        },
        castDataNascimento(value){
            return value.substring(6,10)+"-"+value.substring(3,5)+"-"+value.substring(0,2)
        },
        redirect(){
            this.$router.push({name: 'login'},{});
        }
    }
}
</script>
<style>

</style>