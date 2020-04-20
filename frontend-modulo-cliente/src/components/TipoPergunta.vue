<template>
    <v-container fluid>
          <v-row align="center" align-content="stretch" justify="end">
              <v-col cols="10">
                  <div class="display">
                      Gerenciamento de Tipo de Perguntas
                  </div>
              </v-col>
              <v-col align="end" align-content="stretch" justify="end" cols="2">
                  <v-btn class="ma-2" small fab color="primary" @click="openDialog()">
                      <v-icon color="white">add</v-icon>
                  </v-btn>
              </v-col>     
          </v-row>
          <v-row>
              <v-col>
                  <v-alert type="success" v-if="sucessMessage">
                    Operação realizada com sucesso.
                  </v-alert>
                  <v-data-table
                  :headers="headers"
                  :items="tipoPerguntaList"
                  item-key="name"
                  class="elevation-1"
                  >
                  <template v-slot:item.ativo="{ item }">
                      <v-chip :color="getColor(item.ativo)" dark>{{ item.ativo === 'T' ? 'Ativo':'Inativo' }}</v-chip>
                  </template>
                  <template v-slot:item.acoes="{ item }">
                      <v-row align="center" align-content="stretch" justify="center">
                      <v-col cols="3" sm="1">
                          <v-btn color="primary" text icon small @click="openDialog(item)">
                          <v-icon>edit</v-icon>
                          </v-btn>
                      </v-col>
                      <v-col cols="3" sm="1">
                          <v-switch color="blue" @change="inactive(item)" :input-value="item.ativo==='T'"></v-switch>
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
                      <span class="headline">{{tipoPergunta.codigo ==null ? 'Inserir tipoPergunta' : 'Atualizar tipoPergunta'}}</span>
                  </v-card-title>
                  <v-card-text>
                      <v-container>
                          <v-row>
                              <v-col cols="12" sm="12">
                                  <v-text-field label="tipoPergunta*" required v-model="tipoPergunta.descricao" v-on:keydown.enter="save()" :rules="requiredRule"></v-text-field>
                              </v-col>
                          </v-row>
                      </v-container>
                  </v-card-text>
                  <v-card-actions>
                      <v-spacer></v-spacer>
                      <v-btn color="blue darken-1" text @click="dialog = false">Fechar</v-btn>
                      <v-btn color="blue darken-1" text @click="save()">Salvar</v-btn>
                  </v-card-actions>
              </v-card>
              </v-form>
          </v-dialog>        
    </v-container>  
</template>

<script>

//import tipoPerguntaModel from '@/model/tipoPergunta'

export default {
  created: function(){
      this.getAll();      
  },
  tipoPerguntaList: [],
  data: () => ({
    sucessMessage: false,
    dialog: false,
    tipoPergunta: {},
    selected: [],
    tipoPerguntaList: [],
    formValidated:{},
    requiredRule: [
      v => !!v || 'Campo é requirido'
    ],
    headers: [
        {
          text: 'Descrição',
          align: 'left',
          sortable: true,
          value: 'descricao',
        },
        {
          text: 'Status',
          align: 'center',
          sortable: true,
          value: 'ativo',
        },
        { text: 'Ações', value: 'acoes', align: 'center' },

    ]
  }),
  methods:{
    openDialog(tipoPergunta){
      if(tipoPergunta !== undefined){
        this.tipoPergunta = tipoPergunta;
      }else{
        this.tipoPergunta = {};
      }
      this.dialog = true;
    },
    save(){
      if(this.$refs.form.validate()){
        if(this.tipoPergunta.codigo==null){
        this.tipoPergunta.ativo='T';
        this.sucessMessage = true;
        this.insert(this.tipoPergunta).then(() => {
            this.dialog=false;
            this.getAll();
            setTimeout(()=>{ this.sucessMessage = false; }, 3000);
        })
        }else{
          this.sucessMessage = true;
          this.update(this.tipoPergunta).then(() => {
              this.dialog=false;
              this.getAll();
              setTimeout(()=>{ this.sucessMessage = false; }, 3000);
          });
        }
      }      
    },
    inactive(tipoPergunta){
      tipoPergunta.ativo = tipoPergunta.ativo === 'T'? 'F':'T';
      this.update(tipoPergunta).then(() => {
            this.getAll();
      });
    },
    getAll(){
      this.$http.get('/tipo-pergunta').then(res => {
        this.tipoPerguntaList = res.data;
      });
    },
    update(tipoPergunta){
      return this.$http.put('/tipo-pergunta',tipoPergunta);
    },
    insert(tipoPergunta){
      return this.$http.post('/tipo-pergunta',tipoPergunta);
    },
    getColor (ativo) {
        if (ativo == 'T') return 'green'
        else return 'red'
    }
  }
}
</script>

<style>

</style>
