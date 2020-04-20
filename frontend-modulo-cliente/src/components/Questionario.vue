<template>
    <v-container fluid>
        <v-row>
            <v-col>
                <v-card>
                    <v-card-title>
                        <span>
                            Questionário Pré-triagem
                        </span>
                    </v-card-title>
                    <v-card-text>
                        <v-form
                            ref="form"
                            v-model="formValidated"
                            lazy-validation
                        >
                            <v-row v-for="(pergunta, index) in perguntasParametroList.perguntas" :key="index">
                                <v-col cols="12">
                                    {{(index+1)+". "+pergunta.descricao}}
                                </v-col>
                                <v-col v-if="pergunta.tipoPergunta.codigo == 1">
                                    <v-radio-group v-model="respostas[index].escolhaUnica" row>
                                        <v-radio :label="parametro.descricao" required :rules="requiredRule" :value="parametro.codigo" v-for="(parametro, index) in pergunta.tipoPergunta.parametros" :key="index"></v-radio>
                                    </v-radio-group>
                                </v-col>
                                <v-col v-if="pergunta.tipoPergunta.codigo == 3">
                                    <v-text-field label="Resposta*" outlined placeholder="Resposta" required v-model="respostas[index].texto" :rules="requiredRule"></v-text-field>
                                </v-col>
                                <v-col v-if="pergunta.tipoPergunta.codigo == 4">
                                    <v-text-field
                                        label="Data"
                                        placeholder="Data"
                                        outlined
                                        required
                                        :rules="requiredRule"
                                        v-mask="'##/##/####'"
                                        v-model="respostas[index].data"
                                    ></v-text-field>
                                </v-col>
                                <v-col v-if="pergunta.tipoPergunta.codigo == 5">
                                    <v-text-field label="Resposta*" required outlined v-model="respostas[index].numero" :rules="requiredRule"></v-text-field>
                                </v-col>
                            </v-row>
                            <v-row>
                                <v-col>
                                    <v-btn color="primary" outlined style="width:100%" @click="save()" large :loading="loading">Enviar Resposta</v-btn>
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
    data: () => ({
        perguntasParametroList:[],
        respostas:[],
        formValidated:'',
        requiredRule: [
            v => (!!v) || 'Campo é requirido'
        ],
        loading: false
    }),
    created:function(){
        this.getAll();
    },
    methods:{
        getPerguntas(){

        },
        getAll(){
            this.$http.get('/pergunta-parametro').then(res => {
                this.perguntasParametroList = res.data;
                this.genarateAnswer(this.perguntasParametroList.perguntas);
            });
        },
        genarateAnswer(perguntas){
            for (let index = 0; index < perguntas.length; index++) {
                this.respostas.push({
                    "escolhaUnica": null,
                    "escolhaMultipla": null,
                    "texto": null,
                    "numero": null,
                    "data": null,
                    "arquivo": null
                })                
            }
        },
        save(){
            if(this.$refs.form.validate()){
                this.loading = true;
                this.$http.post("/resposta",this.buildAnswers()).then(()=>{
                    this.loading = false;
                    this.$router.push({name: 'acompanhamento'},{});
                }).finally(()=>{
                     this.loading = false;
                 })
            }
        },
        buildAnswers(){
            var answer = {
                codigoPessoa:localStorage.getItem("codigo_usuario"),
                perguntas:[]
            };

            for (let index = 0; index < this.perguntasParametroList.perguntas.length; index++) {         
                answer.perguntas.push({
                    codigo: null,
                    parametros:[]
                });
                answer.perguntas[index].codigo = this.perguntasParametroList.perguntas[index].codigo;
                if(this.perguntasParametroList.perguntas[index].tipoPergunta.codigo == 4){
                    this.respostas[index].data = this.castData(this.respostas[index].data);
                }
                answer.perguntas[index].parametros = [this.respostas[index]];                  
            }
            return {respostas:
                        answer
                    };
        },
        castData(value){
            return value.substring(6,10)+"-"+value.substring(3,5)+"-"+value.substring(0,2)
        }
    }
}
</script>

<style>

</style>