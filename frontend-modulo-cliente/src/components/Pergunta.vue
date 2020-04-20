<template>
  <v-container fluid>
        <v-row align="center" align-content="stretch" justify="end">
            <v-col cols="10">
                <div class="display">
                    Gerenciamento de Perguntas
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
                :items="perguntaList"
                item-key="name"
                class="elevation-1"
                >
                <template v-slot:item.ativo="{ item }">
                    <v-chip :color="getColor(item.ativo)" dark>{{ item.ativo === 'T' ? 'Ativo':'Inativo' }}</v-chip>
                </template>
                <template v-slot:item.acoes="{ item }">
                    <v-row align="center" align-content="stretch" justify="center">
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
                    <span class="headline">{{pergunta.codigo ==null ? 'Inserir pergunta' : 'Atualizar pergunta'}}</span>
                </v-card-title>
                <v-card-text>
                    <v-container>
                        <v-row>
                            <v-col cols="12" sm="12">
                                <v-text-field label="pergunta*" required v-model="pergunta.descricao" v-on:keydown.enter="save()" :rules="requiredRule"></v-text-field>
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

//import perguntaModel from '@/model/pergunta'

export default {
  created: function(){
      this.getAll();      
  },
  perguntaList: [],
  data: () => ({
    sucessMessage: false,
    dialog: false,
    pergunta: {},
    selected: [],
    perguntaList: [],
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
    openDialog(pergunta){
      if(pergunta !== undefined){
        this.pergunta = pergunta;
      }else{
        this.pergunta = {};
      }
      this.dialog = true;
    },
    save(){
      if(this.$refs.form.validate()){
        if(this.pergunta.codigo==null){
        this.pergunta.ativo='T';
        this.sucessMessage = true;
        this.insert(this.pergunta).then(() => {
            this.dialog=false;
            this.getAll();
            setTimeout(()=>{ this.sucessMessage = false; }, 3000);
        })
        }else{
          this.sucessMessage = true;
          this.update(this.pergunta).then(() => {
              this.dialog=false;
              this.getAll();
              setTimeout(()=>{ this.sucessMessage = false; }, 3000);
          });
        }
      }      
    },
    inactive(pergunta){
      pergunta.ativo = pergunta.ativo === 'T'? 'F':'T';
      this.update(pergunta).then(() => {
            this.getAll();
      });
    },
    getAll(){
      this.$http.get('/pergunta').then(res => {
        this.perguntaList = res.data;
      });
    },
    update(pergunta){
      return this.$http.put('/pergunta',pergunta);
    },
    insert(pergunta){
      return this.$http.post('/pergunta',pergunta);
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
