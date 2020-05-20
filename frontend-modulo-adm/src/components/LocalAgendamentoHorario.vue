<template>
  <v-container fluid>
        <v-row align="center" align-content="stretch" justify="end">
            <v-col cols="10">
                <div class="display">
                    Gerenciamento de Horário por Local
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
                :items="locaAgendamentaHorariolList"
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
                    <span class="headline">{{localcoletaHorario.codigo ==null ? 'Inserir Horario' : 'Atualizar Horário'}}</span>
                </v-card-title>
                <v-card-text>
                    <v-container>
                        <v-row>
                            <v-col cols="12" sm="12">
                                <v-text-field label="Descrição do Local*" required v-model="localcoletaHorario.descricao" :rules="[rules.requiredRule]"></v-text-field>
                            </v-col>
                            <v-col cols="12" sm="12">
                              <v-select
                                v-model="localcoletaHorario.codigo"
                                :items="localList"
                                :rules="requiredRule" 
                                label="Locais"
                                solo
                                required
                                item-text="descricao" 
                                item-value="codigo"                       
                              ></v-select>
                            </v-col>
                            <v-col cols="12" sm="12">
                              <v-select
                                v-model="localcoletaHorario.horarios"
                                :items="horarioList"
                                item-text="hora"
                                return-object
                                label="Selecione os horários"
                                multiple
                                hint="Selecione os horários"
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

//import localcoletaHorarioModel from '@/model/local-agendamento'

export default {
  created: function(){
      this.getAll();
      this.getListLocais();      
      this.getHorarios();     
  },
  localList: [],
  data: () => ({
    sucessMessage: false,
    isLoading: false,
    dialog: false,
    localcoletaHorario: {},
    selected: [],
    locaAgendamentaHorariolList: [],
    localList: [],
    horarioList: [],
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
    openDialog(localcoletaHorario){
      if(localcoletaHorario !== undefined){
        this.localcoletaHorario = localcoletaHorario;
      }else{
        this.localcoletaHorario = {};
      }
      this.dialog = true;
    },
    save(){
      if(this.$refs.form.validate()){
        this.localcoletaHorario.ativo='T';
        this.localcoletaHorario.codigoEmpresa = 1;
        this.insert(this.localcoletaHorario).then(() => {
            this.sucessMessage = true;
            this.dialog=false;
            this.getAll();
            setTimeout(()=>{ this.sucessMessage = false; }, 3000);
        });
      }      
    },
    inactive(localcoletaHorario){
      localcoletaHorario.ativo = localcoletaHorario.ativo === 'T'? 'F':'T';
      this.update(localcoletaHorario).then(() => {
            this.getAll();
      });
    },
    getAll(){
      this.isLoading = true;
      this.$http.get('/local-agendamento-horario').then(res => {      
        this.isLoading = false;
        this.locaAgendamentaHorariolList = res.data.localAgendamento;
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
    getHorarios(){
      this.$http.get('/horario').then(res => {
        this.horarioList = res.data;
      });
    },
    update(localcoletaHorario){
      return this.$http.put('/local-agendamento-horario',localcoletaHorario);
    },
    insert(localcoletaHorario){
      return this.$http.post('/local-agendamento-horario',localcoletaHorario);
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
