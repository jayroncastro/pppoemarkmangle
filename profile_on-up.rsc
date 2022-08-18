# profile_on-up
# Script para automatizar a criacao de regras de mangle e rotas para forcar saida pelo link de entrada
# Development by: Jayron Castro
# Date: 17/08/2022 10:12
# eMail: jayroncastro@gmail.com
{
  #======== VARIAVEL DE CONTROLE =========
  #Na variavel "interfaceLan" deve ser colocado o nome da interface que representa a lan da rede
  #=======================================
  :local interfaceLan "bridge";
  #=======================================

  #Armazena o nome da interface
  :local interfaceName [/interface ethernet get $interface name];

  #Marca conexão entrando pelo link
  /ip firewall mangle add chain=prerouting in-interface=$interface connection-mark="no-mark" action=mark-connection new-connection-mark="in_$interfaceName" comment="** marca conexao entrando pelo link $interfaceName";
  :log debug message=("Regra mangle de marcacao de conexao criada com sucesso");

  #Marca rota de saída dos pacotes da lan pelo link que entrou
  /ip firewall mangle add chain=prerouting in-interface=$interfaceLan connection-mark="in_$interfaceName" action=mark-routing new-routing-mark="out_$interfaceName" passthrough=no comment="** marca rota de saida dos pacotes da lan pelo link $interfaceName";
  :log debug message=("Regra mangle de marcacao de rota criada com sucesso");

  #Marca rota de saída local pela interface de pppoe especificado
  /ip firewall mangle add chain=output src-address=$"local-address" action=mark-routing new-routing-mark="out_$interfaceName" out-interface=$interface passthrough=no comment="** marca rota de saida local pelo link $interfaceName";
  :log debug message=("Regra mangle de marcacao de rota criada com sucesso");

  #Cria rota forcando saida pelo link pppoe especificado
  /ip route add dst-address=0.0.0.0/0 gateway=$interface routing-mark="out_$interfaceName" comment="** tabela de rota para a interface $interfaceName";
  :log debug message=("Tabela de rota $interfaceName criada com sucesso");
}
