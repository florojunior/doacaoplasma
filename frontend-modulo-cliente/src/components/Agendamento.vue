<template>
<div style="width: 100%">
        <v-btn style="width:100%" color="white" @click="openDialog()" outlined :loading="loading">
          <v-icon left>
            sentiment_very_satisfied
          </v-icon>
            Agendar Doacao
        </v-btn>
         <!-- <v-row>
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
          </v-row>-->
          <!-- DIALOG -->
          <v-dialog v-model="dialog" persistent max-width="600px">
            <v-form
              ref="form"
              v-model="formValidated"
              lazy-validation="false"
            >
              <v-card>
                  <v-card-title>
                      <span class="headline">{{agendamento.codigo ==null ? 'Agendamento' : 'Agendamento'}}</span>
                  </v-card-title>
                  <v-card-text>
                      <v-container>
                          <v-row>
                              <v-col cols="12" sm="12">
                                <v-select
                                  v-model="agendamento.codigoLocalAgendamento_ref"
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
                                      label="Selecione a data"
                                      readonly
                                      v-on="on"
                                    ></v-text-field>
                                  </template>
                                  <v-date-picker v-model="picker" :min="dateActual" @input="menu2 = false"></v-date-picker>
                                </v-menu>
                              </v-col>
                              
                              <v-expansion-panels :value="panels">
                                <v-expansion-panel value="0"
                                >
                                  <v-expansion-panel-header>Horários disponiveis
                                    <template v-slot:actions>
                                      <v-icon color="teal">$expand</v-icon>
                                    </template>
                                  </v-expansion-panel-header>
                                  <v-expansion-panel-content>
                                    <v-row>
                                      <v-col v-for="horarioItem in horarioList" :key="horarioItem.codigo" cols="6"  class="d-flex justify-center">
                                        <v-chip
                                          :color="horarioItem.hora == horarioSelecionado.hora ? 'green': 'blue'"
                                          text-color="white"
                                          @click="selecionaHorario(horarioItem)"
                                        >
                                          {{horarioItem.hora}}
                                          <v-icon right color="white">{{horarioItem.hora == horarioSelecionado.hora ? 'check': 'mdi-av-timer'}}</v-icon>
                                        </v-chip>
                                      </v-col>
                                    </v-row>                                   
                                  </v-expansion-panel-content>
                                </v-expansion-panel>
                              </v-expansion-panels>                              
                            </v-row>
                      </v-container>
                  </v-card-text>
                  <v-card-actions>
                      <v-spacer></v-spacer>
                      <v-btn color="blue darken-1" text @click="dialog = false; $refs.form.reset();">Fechar</v-btn>
                      <v-btn color="blue darken-1" text @click="save()" :loading="isLoading">Salvar</v-btn>
                  </v-card-actions>
              </v-card>
              </v-form>
          </v-dialog>
  </div>        
</template>

<script>

//import agendamentoModel from '@/model/agendamento'

export default {
  created: function(){
      this.getAll();
      this.getListLocais();
      this.getHorarios();      
  },
  meusAgendamentosList: [],
  data: () => ({
    loading: false,
    horarioSelecionado:{hora:0},
    panels:[1],
    date: new Date().toISOString().substr(0, 10),
    dateActual: new Date().toISOString().substr(0, 10),
    isLoading: false,
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
    selecionaHorario(horario){
      this.horarioSelecionado = horario;
    },
    openDialog(agendamento){
      if(agendamento !== undefined){
        this.agendamento = agendamento;
      }else{
        this.agendamento = {};
      }
      this.dialog = true;
    },
    save(){
      this.isLoading = true;
      if(this.$refs.form.validate()){
        this.agendamento.data = this.picker;
        this.agendamento.status = "AG";
        this.agendamento.hora = this.horarioSelecionado.hora;
        this.agendamento.codigoLocalAgendamento = this.agendamento.codigoLocalAgendamento_ref.toString();
        if(this.agendamento.codigo==null){
          this.agendamento.ativo='T';

          this.insert(this.agendamento).then(() => {
              this.dialog=false;
              this.getAll();
              this.isLoading = false;
              this.sucessMessage = true;
              setTimeout(()=>{ this.sucessMessage = false; }, 3000);
        })
        }else{
          this.sucessMessage = true;
          this.update(this.agendamento).then(() => {
              this.dialog=false;
              this.getAll();
              this.isLoading = false;
              setTimeout(()=>{ this.sucessMessage = false; }, 3000);
          });
        }
        this.$refs.form.reset();
      }      
    },
    getHorarios(){
      this.isLoading = true;
      this.$http.get('/disponibilidade-agendamento/',{
        params:{
          codigoLocal: 1,
          data: this.dateFormatted
        }
      }).then(res => {
        this.isLoading = false;
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
      /*this.$http.get('/agendamento').then(res => {
        this.meusAgendamentosList = res.data;
      });*/
    },
    getListLocais(){
      this.isLoading = true;
      this.$http.get('/local-agendamento/',{
        params:{
          codigoEmpresa:1
        }
      }).then(res => {
        this.localList = res.data;
        this.isLoading = false;
      });
    },
    update(agendamento){
      return this.$http.put('/agendamento',agendamento);
    },
    insert(){
      return this.$http.post('/agendamento',this.agendamento);
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
