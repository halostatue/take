-module(take_ffi).
-export([with_stdout/1, with_stderr/1]).

with_stdout(Fun) ->
    OldGL = group_leader(),
    Self = self(),
    Pid = spawn_link(fun() -> collector(Self, []) end),
    group_leader(Pid, self()),
    try Fun() of
        Result -> {Result, collect(Pid, Self)}
    catch
        Class:Reason:Stack ->
            collect(Pid, Self),
            erlang:raise(Class, Reason, Stack)
    after
        group_leader(OldGL, self())
    end.

with_stderr(Fun) ->
    Self = self(),
    OldPid = erlang:whereis(standard_error),
    Pid = spawn_link(fun() -> stderr_collector(OldPid, Self, []) end),
    true = erlang:unregister(standard_error),
    true = erlang:register(standard_error, Pid),
    try Fun() of
        Result -> {Result, collect(Pid, Self)}
    catch
        Class:Reason:Stack ->
            collect(Pid, Self),
            erlang:raise(Class, Reason, Stack)
    after
        catch erlang:unregister(standard_error),
        erlang:register(standard_error, OldPid)
    end.

collect(Pid, Self) ->
    Pid ! {done, Self},
    receive {result, Data} -> Data end.

collector(Owner, Acc) ->
    receive
        {io_request, From, ReplyAs, {put_chars, _Enc, Chars}} ->
            From ! {io_reply, ReplyAs, ok},
            collector(Owner, [Acc | to_list(Chars)]);
        {io_request, From, ReplyAs, {put_chars, Chars}} ->
            From ! {io_reply, ReplyAs, ok},
            collector(Owner, [Acc | to_list(Chars)]);
        {done, Owner} ->
            Owner ! {result, unicode:characters_to_binary(lists:flatten(Acc))}
    end.

stderr_collector(OldPid, Owner, Acc) ->
    receive
        {io_request, From, ReplyAs, {put_chars, _Enc, Chars}} ->
            From ! {io_reply, ReplyAs, ok},
            stderr_collector(OldPid, Owner, [Acc | to_list(Chars)]);
        {io_request, From, ReplyAs, {put_chars, Chars}} ->
            From ! {io_reply, ReplyAs, ok},
            stderr_collector(OldPid, Owner, [Acc | to_list(Chars)]);
        {io_request, From, ReplyAs, Req} ->
            OldPid ! {io_request, From, ReplyAs, Req},
            stderr_collector(OldPid, Owner, Acc);
        {done, Owner} ->
            Owner ! {result, unicode:characters_to_binary(lists:flatten(Acc))}
    end.

to_list(B) when is_binary(B) -> binary_to_list(B);
to_list(L) when is_list(L) -> L.
