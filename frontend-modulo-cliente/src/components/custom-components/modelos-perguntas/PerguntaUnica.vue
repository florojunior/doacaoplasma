<template>
    <div>
        <v-row>
            <v-col align="end" align-content="stretch" justify="end" cols="2">
                <v-btn class="ma-2" small fab color="primary">
                    <v-icon color="white">add</v-icon>
                </v-btn>
            </v-col>    
        </v-row>
        <v-card>
            <v-card-title>
                <v-row>
                    <v-col>
                        <v-select
                            :items="perguntaList"
                            label="Escolha a pergunta"
                            solo
                            item-text="codigo" 
                            item-value="descricao" 
                        ></v-select>
                    </v-col>                    
                </v-row>
            </v-card-title>
            <v-card-text>
                <v-row>
                    <v-col class="d-flex" cols="6">
                        <v-select
                        :items="tipoPerguntaList"
                        label="Tipo de Pergunta"
                        solo
                        item-text="descricao" 
                        item-value="codigo" 
                           
                        ></v-select>
                    </v-col>
                    <v-col>
                        <v-btn class="ma-2" small fab color="primary">
                            <v-icon color="white" @click="adicionarNovoParametro()">add</v-icon>
                        </v-btn>
                    </v-col>
                </v-row>
                <v-row>
                    <v-col>
                        <v-row v-for="(parametro , index) in listParametros" :key="index">
                            <v-text-field label="Paramtro" required v-model="parametro[index].descricao" :rules="requiredRule"></v-text-field>
                        </v-row>
                    </v-col>
                </v-row>
            </v-card-text>
        </v-card>
        
    </div>
</template>
<script>
export default {
    data: () => ({
        pergunta: {},
        formValidated:{},
        requiredRule: [
        v => !!v || 'Campo é requirido'
        ],
        tipoPerguntaList:[],
        listParametros:[],
        perguntaList:[]
    }),
    created: function(){
        this.carregarTiposPerguntas();
    },
    methods:{
        carregarPerguntas(){
            this.$http.get('/perguntas').then((res)=>{
                this.tipoPerguntaList = res.data;
            });
        },
        carregarTiposPerguntas(){
            this.$http.get('/tipo-pergunta').then((res)=>{
                this.tipoPerguntaList = res.data;
            });
        },
        adicionarNovoParametro(){
            this.listParametros.push({});
        }
    }

}
</script>
<style>

</style>