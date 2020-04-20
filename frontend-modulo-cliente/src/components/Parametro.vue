<template>
  <v-container fluid>
        <v-row align="center" align-content="stretch" justify="end">
            <v-col cols="10">
                <div class="display">
                    Gerenciamento de Parametros
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
                :items="parametroList"
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
                    <span class="headline">{{parametro.codigo ==null ? 'Inserir parametro' : 'Atualizar parametro'}}</span>
                </v-card-title>
                <v-card-text>
                    <v-container>
                        <v-row>
                            <v-col cols="12" sm="12">
                                <v-text-field label="Parametro*" required v-model="parametro.descricao" v-on:keydown.enter="save()" :rules="requiredRule"></v-text-field>
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
    selected: [],
    parametroList: [],
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
    openDialog(parametro){
      if(parametro !== undefined){
        this.parametro = parametro;
      }else{
        this.parametro = {};
      }
      this.dialog = true;
    },
    save(){
      if(this.$refs.form.validate()){
        if(this.parametro.codigo==null){
        this.parametro.ativo='T';
        this.sucessMessage = true;
        this.insert(this.parametro).then(() => {
            this.dialog=false;
            this.getAll();
            setTimeout(()=>{ this.sucessMessage = false; }, 3000);
        })
        }else{
          this.sucessMessage = true;
          this.update(this.parametro).then(() => {
              this.dialog=false;
              this.getAll();
              setTimeout(()=>{ this.sucessMessage = false; }, 3000);
          });
        }
      }      
    },
    inactive(parametro){
      parametro.ativo = parametro.ativo === 'T'? 'F':'T';
      this.update(parametro).then(() => {
            this.getAll();
      });
    },
    getAll(){
      this.$http.get('/parametro').then(res => {
        this.parametroList = res.data;
      });
    },
    update(parametro){
      return this.$http.put('/parametro',parametro);
    },
    insert(parametro){
      return this.$http.post('/parametro',parametro);
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
