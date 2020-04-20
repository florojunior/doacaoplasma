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
                <v-timeline :dense="$vuetify.breakpoint.smAndDown" :reverse="true">
                    <v-timeline-item
                        color="blue lighten-1"
                        fill-dot
                        >
                        <v-card>
                            <v-card-title class="blue lighten-1">
                                <v-icon
                                    dark
                                    size="32"
                                    class="mr-4"
                                >
                                    check
                                </v-icon>
                                <h2 class="subtitle-1 white--text font-weight-light">Pré-Cadastro Realizado</h2>
                            </v-card-title>
                        </v-card>
                    </v-timeline-item>

                    <v-timeline-item
                        :color="status.passou=='T'?'blue lighten-1':'red lighten-1'"
                        fill-dot
                        v-for="status in listStatus"
                        :key="status"
                        >
                        <v-card>
                            <v-card-title class="lighten-1" :class="status.passou=='T'?'blue':'red'">
                                <v-icon
                                    dark
                                    size="32"
                                    class="mr-4"
                                >
                                    {{status.passou=='T'?'check':'mdi-cancel'}}
                                </v-icon>
                                <h2 class="subtitle-1 white--text font-weight-light">{{status.descricao}}</h2>
                            </v-card-title>
                        </v-card>
                    </v-timeline-item>
                </v-timeline>
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