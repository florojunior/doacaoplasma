<template>
    <v-container>
        <v-card>
            <v-card-title>
                <v-row class="d-flex justify-center align-center">
                    <v-col cols="12" class="d-flex justify-center align-center">
                        <h1 class="title font-weight-medium" color="primary" style="text-align: center;">Seu Status :)</h1>
                    </v-col>
                    <v-col cols="12" class="d-flex justify-center align-center">
                        <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS7YtQSAUawe-N13IDCUYFjRocjDLb5WeS2Myewbh9whmJ_bqDW&usqp=CAU" alt="">
                    </v-col>
                </v-row>
                
            </v-card-title>
            <v-card-text>
                <v-row>
                    <v-col cols="6">
                        <v-btn style="width:100%" color="primary" text @click="realizarTriagem()" large :loading="loading" outlined>Pré-Triagem</v-btn>
                    </v-col>
                    <v-col cols="6">
                        <v-btn style="width:100%" color="primary" text @click="agendarDoacao()" large :loading="loading" outlined>Agendar Doação</v-btn>
                    </v-col>    
                </v-row>
            </v-card-text>
        </v-card>
    </v-container>
</template>
<script>
export default {
    created: function(){
        this.carregarStatus();
    },
    data: () => ({
        requiredRule: [
            v => (!!v) || 'Campo é requirido'
        ],
        listStatus:[]
    }),
    methods:{
        carregarStatus(){
            this.$http.get("/acompanhamento-pessoa/",{
                params:{
                    codigoPessoa: this.codigoPessoa
                }
            }).then((res)=>{
                this.listStatus = res.data;
                console.log(this.listStatus);
                if(this.listStatus.length == 0){
                    this.$router.push({name: 'questionario'},{});
                }
            })
        },
        agendarDoacao(){
            
        },
        realizarTriagem(){

        }
    },
    computed:{
        codigoPessoa(){
            return localStorage.getItem("codigo_usuario");
        }
    }
}
</script>
<style>

</style>