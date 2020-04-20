<template>
  <v-container fluid>
        <v-row align="center" align-content="stretch" justify="end">
            <v-col cols="12">
                <div class="display">
                    Lista de Voluntários
                </div>
            </v-col>  
        </v-row>
        <v-row>
            <v-col>
                <v-alert type="success" v-if="sucessMessage">
                  Operação realizada com sucesso.
                </v-alert>
                <v-data-table
                :headers="headers"
                :items="parametroList"
                item-key="name"
                class="elevation-1"
                >
                <template v-slot:item.acoes="{ item }">
                    <v-row align="center" align-content="stretch" justify="center">
                    <v-col cols="3" sm="1">
                        <v-btn icon color="pink" @click="detalhar(item)">
                          <v-icon>mdi-pencil</v-icon>
                        </v-btn>
                    </v-col>
                    </v-row>
                </template>
                </v-data-table>
            </v-col>
        </v-row>
        <!-- DIALOG -->
        <v-dialog v-model="dialog" persistent max-width="600px">
          <v-form
            ref="form"
            v-model="formValidated"
            lazy-validation
          >
            <v-card>
                <v-card-title>
                    <span class="headline">Respostas do Voluntário</span>
                </v-card-title>
                <v-card-text>
                    <v-container>
                        <v-row v-for="(pergunta,index) in selected.pergunta" :key="index">
                            <v-col cols="12" sm="12">
                              <span class="subtitle-2 font-weight-bold">
                                {{(index+1)+'-'+' '+pergunta.descricao}}
                              </span> 
                            </v-col>
                            <v-col cols="12" v-if="pergunta.parametros[0].escolhaUnica != null">
                              <span class="subtitle-2 font-weight-light">
                                {{'Resposta = '+pergunta.parametros[0].escolhaUnica}}
                              </span> 
                            </v-col>
                            <v-col cols="12" v-if="pergunta.parametros[0].texto != null">
                              <span class="subtitle-2 font-weight-light">
                                {{'Resposta = '+pergunta.parametros[0].texto}}
                              </span> 
                            </v-col>
                            <v-col cols="12" v-if="pergunta.parametros[0].data != null">
                              <span class="subtitle-2 font-weight-light">
                                {{'Resposta = '+pergunta.parametros[0].data}}
                              </span> 
                            </v-col>
                            <v-col cols="12" v-if="pergunta.parametros[0].numero != null">
                              <span class="subtitle-2 font-weight-light">
                                {{'Resposta = '+pergunta.parametros[0].numero}}
                              </span> 
                            </v-col>
                            <v-col cols="12">
                               <v-divider></v-divider>
                            </v-col>
                           
                        </v-row>
                    </v-container>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue darken-1" text @click="dialog = false">Fechar</v-btn>
                </v-card-actions>
            </v-card>
            </v-form>
        </v-dialog>
  </v-container>  
</template>

<script>

//import parametroModel from '@/model/parametro'

export default {
  created: function(){
      this.getAll();      
  },
  parametroList: [],
  data: () => ({
    sucessMessage: false,
    dialog: false,
    parametro: {},
    parametroList: [],
    formValidated:{},
    selected: {},
    requiredRule: [
      v => !!v || 'Campo é requirido'
    ],
    headers: [
        {
          text: 'Nome',
          align: 'left',
          sortable: true,
          value: 'nome',
        },
        { text: 'Ações', value: 'acoes', align: 'center' },

    ]
  }),
  methods:{
    detalhar(item){
      this.selected = item;
      this.dialog = true;
    },  
    getAll(){
      this.$http.get('/resposta').then(res => {
        this.parametroList = res.data.respostas;
      });
    }
  }
}
</script>

<style>

</style>
