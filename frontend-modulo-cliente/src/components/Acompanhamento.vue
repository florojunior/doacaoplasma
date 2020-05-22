<template>
    <v-container>
        <v-row>
            <v-col>
                <v-card elevation="5">
                    <v-card-title style="display:flex; justify-content: center">
                        <p class="headline text-center font-weight-medium text--secondary">Painel do doador</p>
                    </v-card-title>
                    <v-card-text>
                        <v-row>
                            <v-col cols="12" md="6" lg="6" xl="6">
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
                            {{ isLoading}}
                            <v-col cols="12" v-if="agendamentoResult==null && !isLoading" md="6" lg="6" xl="6">
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
                            <v-col cols="12" v-if="agendamentoResult!=null" md="6" lg="6" xl="6">
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
                                                Doação Agendada
                                                <v-icon right>calendar_today</v-icon>
                                            </v-card-title>
                                            
                                            <v-card-subtitle v-text="agendamentoResult != null?('Data: '+ agendamentoResult.data+' '+agendamentoResult.hora): 'Carregando...'"  ></v-card-subtitle>
                                            <v-card-actions>
                                                <v-btn style="width:100%" color="white" @click="cancelarAgendamento()" outlined>
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
            </v-col>
        </v-row>
        <v-overlay :value="overlay">
            <v-progress-circular indeterminate size="64"></v-progress-circular>
        </v-overlay>
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
        agendamentoResult:null,
        overlay: false
    }),
    methods:{
        checkAgendamento(){
            this.$http.get("/verifica-agendamento").then((res)=>{
                console.log(res);
                if(res.status == 204){
                    this.agendamentoResult = null;
                }else if(res.data.status == "F"){
                     this.agendamentoResult = null;
                }else{
                    this.agendamentoResult = res.data.dadosAgendamento[0];
                }
                
            });
        },
        cancelarAgendamento(){
            this.overlay = true;
            this.$http.put('/agendamento',{
                codigoAgendamento : this.agendamentoResult.codigoAgendamento
            }).then((res)=>{
                this.overlay = false;
                if(res.status == 200)
                    this.checkAgendamento();

            })
        },
        carregarStatus(){
            this.overlay = true;
            this.$http.get("/acompanhamento-pessoa/",{
                params:{
                    codigoPessoa: this.codigoPessoa
                }
            }).then((res)=>{
                this.listStatus = res.data;
                this.overlay = false;
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