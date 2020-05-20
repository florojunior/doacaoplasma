<template>
    <v-container fluid>
          <v-row align="center" align-content="stretch" justify="end">
              <v-col cols="10">
                  <div class="display">
                      Meus Agendamentos
                  </div>
              </v-col>
              <v-col align="end" align-content="stretch" justify="end" cols="2">
                  <v-btn color="primary" @click="openDialog()">
                      Novo Agendamento
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
                  :items="meusAgendamentosList"
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
                      <span class="headline">{{agendamento.codigo ==null ? 'Inserir Agendamento' : 'Atualizar Agendamento'}}</span>
                  </v-card-title>
                  <v-card-text>
                      <v-container>
                          <v-row>
                              <v-col cols="12" sm="12">
                                <v-select
                                  v-model="agendamento.codigoLocalAgendamento"
                                  :items="localList"
                                  :rules="requiredRule" 
                                  label="Selecione o local"
                                  required
                                  item-text="descricao" 
                                  item-value="codigo"                       
                                ></v-select>
                              </v-col>
                              <v-col>
                                <v-menu
                                  v-model="menu2"
                                  :close-on-content-click="false"
                                  :nudge-right="40"
                                  transition="scale-transition"
                                  offset-y
                                  min-width="290px"
                                >
                                  <template v-slot:activator="{ on }">
                                    <v-text-field
                                      v-model="dateFormatted"
                                      label="Picker without buttons"
                                      prepend-icon="event"
                                      readonly
                                      v-on="on"
                                    ></v-text-field>
                                  </template>
                                  <v-date-picker v-model="picker" @input="menu2 = false"></v-date-picker>
                                </v-menu>
                              </v-col>
                              <v-col cols="12" sm="12">
                                <v-select
                                  v-model="agendamento.horario"
                                  :items="horarioList"
                                  item-text="hora"
                                  return-object
                                  label="Selecione o horário"
                                  persistent-hint
                                ></v-select>
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

//import agendamentoModel from '@/model/agendamento'

export default {
  created: function(){
      this.getAll();
      this.getListLocais();
            
  },
  meusAgendamentosList: [],
  data: () => ({
    date: new Date().toISOString().substr(0, 10),
    menu2: false,
    sucessMessage: false,
    picker: new Date().toISOString().substr(0, 10),
    dialog: false,
    agendamento: {},
    selected: [],
    horarioList: [],
    meusAgendamentosList: [],
    localList: [],
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
  watch: {
    // whenever question changes, this function will run
    picker: function () {
      this.getHorarios(); 
    }
  },
  computed:{
    dateFormatted: function () {
      var day = this.picker.substring(8,10);
      var month = this.picker.substring(5,7);
      var year = this.picker.substring(0,4);

      return day+"/"+month+"/"+year;
    }
  },
  methods:{
    openDialog(agendamento){
      if(agendamento !== undefined){
        this.agendamento = agendamento;
      }else{
        this.agendamento = {};
      }
      this.dialog = true;
    },
    save(){
      if(this.$refs.form.validate()){
        if(this.agendamento.codigo==null){
        this.agendamento.ativo='T';
        this.sucessMessage = true;
        this.insert(this.agendamento).then(() => {
            this.dialog=false;
            this.getAll();
            setTimeout(()=>{ this.sucessMessage = false; }, 3000);
        })
        }else{
          this.sucessMessage = true;
          this.update(this.agendamento).then(() => {
              this.dialog=false;
              this.getAll();
              setTimeout(()=>{ this.sucessMessage = false; }, 3000);
          });
        }
      }      
    },
    getHorarios(){
      this.$http.get('/disponibilidade-agendamento/',{
        params:{
          codigoLocal: 1,
          data: this.dateFormatted
        }
      }).then(res => {
        this.horarioList = res.data;
      });
    },
    inactive(agendamento){
      agendamento.ativo = agendamento.ativo === 'T'? 'F':'T';
      this.update(agendamento).then(() => {
            this.getAll();
      });
    },
    getAll(){
      this.$http.get('/tipo-pergunta').then(res => {
        this.meusAgendamentosList = res.data;
      });
    },
    getListLocais(){
      this.$http.get('/local-agendamento/',{
        params:{
          codigoEmpresa:1
        }
      }).then(res => {
        this.localList = res.data;
      });
    },
    update(agendamento){
      return this.$http.put('/tipo-pergunta',agendamento);
    },
    insert(agendamento){
      return this.$http.post('/tipo-pergunta',agendamento);
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
