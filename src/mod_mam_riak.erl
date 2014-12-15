%%%'   HEADER
%% @doc ejabberd module that ... listens to packets sent & received by users.
%% @end

-module(mod_myejabberdmod).

%-behaviour(gen_mod).

-export([start/2, init/2, stop/1]).

%-include_lib("ejabberd.hrl").
%-include("jlib.hrl").

-export([
         mam_behaviour/5,
         archive_message/9
        ]).

-define(PROCNAME, mod_mam_riak).

-ifdef(TEST).
-compile(export_all).
-endif.

%%%.
%%%'   CALLBACKS

start(Host, Opts) ->
  %Opt1 = gen_mod:get_opt(opt1, Opts, "default value"),
  % capture packets sent by user
  ejabberd_hooks:add(mam_get_behaviour, Host, ?MODULE, mam_behaviour, 90),
  ejabberd_hooks:add(mam_archive_message, Host, ?MODULE, archive_message, 90),
  % capture packets received by user
  %ejabberd_hooks:add(user_receive_packet, Host, ?MODULE, receive_packet, 90),
  % register the module process for Host and spawn.
  %register(gen_mod:get_module_proc(Host, ?PROCNAME),
    %spawn(?MODULE, init, [Host, Opt1])),
  gen_server:start_link(?PROCNAME, [Host, Opts], []).

stop(Host) ->
  ejabberd_hooks:delete(mam_get_behaviour, Host, ?MODULE, mam_behaviour, 90),
  ejabberd_hooks:delete(mam_archive_message, Host, ?MODULE, archive_message, 90),
  % remove hook for packets sent by user
  %ejabberd_hooks:delete(user_send_packet, Host, ?MODULE, send_packet, 90),
  %% remove hook for packets received by user
  %ejabberd_hooks:delete(user_receive_packet, Host, ?MODULE, receive_packet, 90),
  % send stop message to process
  ok.

init(Host, Opt1) ->
  % do something here instead of nothing
  ok.


%%%.
%%%'   PUBLIC API

%% @spec send_packet(FromJID, ToJID, P) -> ??
%% @doc
%% @end
-spec mam_behaviour(Default :: roster | always | never,
                    Host :: ejabberd:server(),
                    ArcID :: non_neg_integer(),
                    LocJID :: jlib:jid(),
                    RemJID :: jlib:jid()) -> { roster | always | never, [jlib:jid()], [jlib:jid()]}.
mam_behaviour(_Default, _Host, _ArcID, _LocJID, _RemJID) ->
  {always, [], []}.

%-spec archive_message(Result, Host, MessID, UserID, LocJID, RemJID, SrcJID, Dir, Packet) -> any() | {error, any()}.
archive_message(Result, Host, MessID, UserID, LocJID, RemJID, SrcJID, Dir, Packet) ->
  try
    unsafe_archive_message(Result, Host, MessID, UserID, LocJID, RemJID, SrcJID, Dir, Packet)
  catch _Type:Reason ->
        {error, Reason}
  end.
%%%.
%%%'   PRIVATE FUNCTIONS

unsafe_archive_message(Result, Host, MessID, UserID, LocJID, RemJID, SrcJID, Dir, Packet) ->
  ok.

%% @private
%%%.


%%% vim: set filetype=erlang tabstop=2 foldmarker=%%%',%%%. foldmethod=marker:
