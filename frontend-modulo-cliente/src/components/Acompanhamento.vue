<template>
    <v-container>
        <v-card>
            <v-card-text style="height: 100%">
                <v-row style="width:100%; height: 100%">
                    <v-col cols="12">
                        <v-card
                            color="blue"
                            dark
                            outlined
                            raised
                            elevation
                        >
                            <div class="d-flex flex-no-wrap justify-space-between">
                                <div style="width: 100%">
                                    <v-card-title
                                        class="headline"
                                        style="display: flex;justify-content: space-between;"
                                    >   
                                        Pré-triagem
                                        <v-icon right>check</v-icon>
                                    </v-card-title>
                                    <v-card-subtitle v-text="'Responda o questionário. É simples e rápido. :D'">                                        
                                    </v-card-subtitle>
                                    <v-card-actions>
                                        <Questionario/>
                                    </v-card-actions>
                                </div>
                            </div>
                        </v-card>
                    </v-col>
                    <v-col cols="12" v-if="agendamentoResult==null">
                        <v-card
                            color="green"
                            dark
                            outlined
                            raised
                            elevation
                        >
                            <div class="d-flex flex-no-wrap justify-space-between">
                                <div style="width: 100%">
                                    <v-card-title
                                        class="headline"
                                        style="display: flex;justify-content: space-between;"
                                    >   
                                        Agendar doação
                                        <v-icon right>calendar_today</v-icon>
                                    </v-card-title>
                                    <v-card-subtitle v-text="'Veja o melhor horário para você e agenda sua doação :D'"></v-card-subtitle>
                                    <v-card-actions>
                                        <Agendamento/>
                                    </v-card-actions>
                                </div>
                            </div>
                        </v-card>
                    </v-col>  
                    <v-col cols="12" v-if="agendamentoResult!=null">
                        <v-card
                            color="orange"
                            dark
                            outlined
                            raised
                            elevation
                        >
                            <div class="d-flex flex-no-wrap justify-space-between">
                                <div style="width: 100%">
                                    <v-card-title
                                        class="headline"
                                        style="display: flex;justify-content: space-between;"
                                    >   
                                        Doação
                                        <v-icon right>calendar_today</v-icon>
                                    </v-card-title>
                                    <v-card-subtitle v-text="'Você possui uma doação agendada para o dia'+ agendamentoResult.data"></v-card-subtitle>
                                    <v-card-actions>
                                        <v-btn style="width:100%" color="white" @click="openDialog()" outlined>
                                            <v-icon left>
                                                cancel
                                            </v-icon>
                                                CANCELAR AGENDAMENTO  
                                        </v-btn>
                                    </v-card-actions>
                                </div>
                            </div>
                        </v-card>
                    </v-col>  
                </v-row>
            </v-card-text>
        </v-card>
    </v-container>
</template>
<script>

import Agendamento from './Agendamento';
import Questionario from './Questionario';

export default {
    components:{
        Agendamento,
        Questionario
    },
    created: function(){
        this.carregarStatus();
        this.checkAgendamento();
    },
    data: () => ({
        requiredRule: [
            v => (!!v) || 'Campo é requirido'
        ],
        listStatus:[],
        agendamentoResult:{}
    }),
    methods:{
        checkAgendamento(){
            this.$http.get("/verifica-agendamento").then((res)=>{
                if(res.status == 204){
                    this.agendamentoResult = null;
                }else{
                    this.agendamentoResult = res.data;
                }
                
            });
        },
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