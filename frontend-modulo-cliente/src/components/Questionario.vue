<template>
    <div style="width: 100%">
        <v-btn style="width:100%" color="white" @click="openDialog()" outlined :loading="loading">
          <v-icon left>
            sentiment_very_satisfied
          </v-icon>
            INICIAR TRIAGEM
        </v-btn>
        <v-dialog v-model="dialog" persistent max-width="600px">
            <v-card>
                    <v-card-title>
                        <span>
                            Questionario Pré-triagem
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
                        </v-form>
                    </v-card-text>
                    <v-card-actions>
                        <v-row>
                            <v-col cols="6" class="d-flex justify-center">
                                <v-btn style="width: 100%" color="blue darken-1" outlined large @click="dialog = false">Cancelar</v-btn>
                            </v-col>
                            <v-col cols="6" class="d-flex justify-center">
                                <v-btn style="width: 100%" color="primary" outlined @click="save()" large :loading="loading">Enviar</v-btn>
                            </v-col>
                        </v-row>
                    </v-card-actions>
                </v-card>
        </v-dialog>
    </div>    
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
        loading: false,
        dialog : false
    }),
    methods:{
        openDialog(respostas){
            this.getAll();
            if(respostas !== undefined){
                this.respostas = respostas;
            }else{
                this.respostas = [];
            }
            this.dialog = true;
        },
        getPerguntas(){

        },
        getAll(){
            this.loading = true;
            this.$http.get('/pergunta-parametro').then(res => {
                this.loading = false;
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