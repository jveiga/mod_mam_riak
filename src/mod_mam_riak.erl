%%%'   HEADER
%% @doc ejabberd module that ... listens to packets sent & received by users.
%% @end

-module(mod_mam_riak).

%-behaviour(gen_mod).

% gen_mod callbacks
-export([start/2, stop/1]).

%-include_lib("ejabberd.hrl").
%-include("jlib.hrl").

-export([
         mam_behaviour/5,
         archive_message/9,
         lookup_message/14
        ]).

-define(PROCNAME, mod_mam_riak).

-ifdef(TEST).
-compile(export_all).
-endif.

%%%.
%%%'   CALLBACKS

start(Host, _Opts) ->
  ejabberd_hooks:add(mam_get_behaviour, Host, ?MODULE, mam_behaviour, 90),
  ejabberd_hooks:add(mam_archive_message, Host, ?MODULE, archive_message, 90),
  ejabberd_hooks:add(mam_lookup_messages, Host, ?MODULE, lookup_message, 90),
  ok.

stop(Host) ->
  ejabberd_hooks:delete(mam_get_behaviour, Host, ?MODULE, mam_behaviour, 90),
  ejabberd_hooks:delete(mam_archive_message, Host, ?MODULE, archive_message, 90),
  ejabberd_hooks:delete(mam_lookup_messages, Host, ?MODULE, lookup_message, 90),
  ok.

%%%.
%%%'   PUBLIC API

%% @spec
%% @doc
%% @end
-spec mam_behaviour(Default :: roster | always | never,
                    Host :: ejabberd:server(),
                    ArcID :: non_neg_integer(),
                    LocJID :: jlib:jid(),
                    RemJID :: jlib:jid()) -> { roster | always | never, [jlib:jid()], [jlib:jid()]}.
mam_behaviour(_Default, _Host, _ArcID, _LocJID, _RemJID) ->
  {always, [], []}.

%% @spec
%% @doc
%% @end
%-spec archive_message(Result, Host, MessID, UserID, LocJID, RemJID, SrcJID, Dir, Packet) -> any() | {error, any()}.
archive_message(Result, Host, MessID, UserID, LocJID, RemJID, SrcJID, Dir, Packet) ->
  try
    unsafe_archive_message(Result, Host, MessID, UserID, LocJID, RemJID, SrcJID, Dir, Packet)
  catch _Type:Reason ->
        {error, Reason}
  end.

%% @spec
%% @doc
%% @end
lookup_message(Result, Host,
                UserID, UserJID, RSM, Borders,
                Start, End, Now, WithJID,
                PageSize, LimitPassed, MaxResultLimit,
                IsSimple) ->
  try
    unsafe_lookup_message(Result, Host,
                UserID, UserJID, RSM, Borders,
                Start, End, Now, WithJID,
                PageSize, LimitPassed, MaxResultLimit,
                IsSimple)
  catch _Type:Reason ->
          {error, Reason}
  end.
%%%.
%%%'   PRIVATE FUNCTIONS

%% @private
unsafe_archive_message(Result, Host, MessID, UserID, LocJID, RemJID, SrcJID, Dir, Packet) ->
  ok.

%% @private
unsafe_lookup_message(Result, Host,
                UserID, UserJID, RSM, Borders,
                Start, End, Now, WithJID,
                PageSize, LimitPassed, MaxResultLimit,
                IsSimple) ->
  ok.


%%%.


%%% vim: set filetype=erlang tabstop=2 foldmarker=%%%',%%%. foldmethod=marker:
