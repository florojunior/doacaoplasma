<template>
  <v-container fluid>
        <v-row align="center" align-content="stretch" justify="end">
            <v-col cols="10">
                <div class="display">
                    Gerenciamento de Local de Coleta
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
                :items="localList"
                item-key="name"
                class="elevation-1"
                :loading="isLoading"
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
                    <span class="headline">{{localColeta.codigo ==null ? 'Inserir localColeta' : 'Atualizar localColeta'}}</span>
                </v-card-title>
                <v-card-text>
                    <v-container>
                        <v-row>
                            <v-col cols="12" sm="12">
                                <v-text-field label="Descrição do Local*" required v-model="localColeta.descricao" :rules="[rules.requiredRule]"></v-text-field>
                            </v-col>
                            <v-col cols="12" sm="12">
                                <v-text-field label="Quantidade*" required v-model="localColeta.quantidadeVagas" :rules="[rules.requiredRule, rules.number]"></v-text-field>
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

//import localColetaModel from '@/model/local-agendamento'

export default {
  created: function(){
      this.getAll();      
  },
  localList: [],
  data: () => ({
    sucessMessage: false,
    dialog: false,
    localColeta: {},
    isLoading: false,
    selected: [],
    localList: [],
    formValidated:{},
    rules:{
      number: value => {
        const pattern = /[^0-9.]/g
        return !pattern.test(value) || 'Apenas numeros'
      },
      requiredRule : value=> {
        return !!value || 'Campo Requerido';
      }
    },
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
    openDialog(localColeta){
      if(localColeta !== undefined){
        this.localColeta = localColeta;
      }else{
        this.localColeta = {};
      }
      this.dialog = true;
    },
    save(){
      if(this.$refs.form.validate()){
        if(this.localColeta.codigo==null){
        this.localColeta.ativo='T';
        this.localColeta.codigoEmpresa = 1;
        this.insert(this.localColeta).then(() => {
            this.sucessMessage = true;
            this.dialog=false;
            this.getAll();
            setTimeout(()=>{ this.sucessMessage = false; }, 3000);
        })
        }else{
          this.update(this.localColeta).then(() => {
              this.sucessMessage = true;
              this.dialog=false;
              this.getAll();
              setTimeout(()=>{ this.sucessMessage = false; }, 3000);
          });
        }
      }      
    },
    inactive(localColeta){
      localColeta.ativo = localColeta.ativo === 'T'? 'F':'T';
      this.update(localColeta).then(() => {
            this.getAll();
      });
    },
    getAll(){
      this.isLoading = true;
      this.$http.get('/local-agendamento/', {
        params:{
          codigoEmpresa: 1
        }
      }).then(res => {
        this.isLoading = false;
        this.localList = res.data;
      });
    },
    update(localColeta){
      return this.$http.put('/local-agendamento',localColeta);
    },
    insert(localColeta){
      return this.$http.post('/local-agendamento',localColeta);
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
