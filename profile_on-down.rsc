# profile_on-down
# Script para automatizar a remocao de regras de mangle e rotas criadas pelo evento On-Up
# Development by: Jayron Castro
# Date: 18/08/2022 18:42
# eMail: jayroncastro@gmail.com
{
  #Armazena o nome da interface
  :local interfaceName [/interface ethernet get $interface name];
  :log warning "initializing script profile(on-down) for interface $interfaceName";
  :log debug "Profile(on-down) -> interface: $interfaceName";

  #Remove regras mangle para marcacao de rotas
  :log debug "initiating deletion of mangle rules with route marking $in_$interfaceName";
  /ip firewall mangle remove [find new-routing-mark="out_$interfaceName"];
  :log debug "finalizing deletion of mangle rules with route marking $in_$interfaceName";

  #Remove regras mangle de marcacao de conexao
  :log debug "initiating deletion of mangle rules with connection markup $in_$interfaceName";
  /ip firewall mangle remove [find new-connection-mark="in_$interfaceName"];
  :log debug "finalizing deletion of mangle rules with connection markup $in_$interfaceName";

  #Remove tabela de rota especifica do link pppoe
  :log debug "initializing specific route deletion for link $in_$interfaceName";
  #/ip route remove [find routing-mark="out_$interfaceName"];
  :log debug "gateway: $interfaceName";
  :log debug "routingMark: out_$interfaceName";
  /ip route remove [find gateway=$interfaceName routing-mark="out_$interfaceName"];
  :delay 1;
  :log debug "finalizing specific route deletion for link $in_$interfaceName";

   #Executa instrução somente se a opção "add-default-route" não estiver selecionada
  :if (![/interface pppoe-client get [find name=$interfaceName] add-default-route]) do={
    :log debug "initialize general route deletion for interface $interfaceName";
    /ip route remove [find comment="** link: $interfaceName"];
    :log debug "finalizing general route deletion for interface $interfaceName";
    :delay 1;
  };
  :log warning "finalizing script profile(on-down) for interface $interfaceName";
}