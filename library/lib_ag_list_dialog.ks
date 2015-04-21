// This file is distributed under the terms of the MIT license, (c) the KSLib team

@LAZYGLOBAL OFF.

run lib_raw_user_input.

function menu_dialog
{
  parameter title.
  parameter options. // a list of list(ag_name, menu_line)

  // print
  clearscreen.
  print title.
  for option in options
  {
    print option[1].
  }
  // set up parameters for wait_for_actiongroups
  local ag_to_listen is list().
  for option in options
  {
    ag_to_listen:add(option[0]).
  }
  // wait & return
  return wait_for_action_groups(ag_to_listen).
}

function list_dialog
{
  parameter title.
  parameter list. // to-do: add support for lists longer when the screen
  parameter status_text.
  parameter ag_exit_list.
  parameter ag_up, ag_down.

  // print
  clearscreen.
  print title.
  local iter is list:iterator.
  until not iter:next
  {
    print iter:value at (2, iter:index + 2).
  }
  print status_text at (0, terminal:height - 1).
  // set up parameters for wait_for_actiongroups
  local ag_to_listen is ag_exit_list:copy().
  ag_to_listen:add(ag_up).
  ag_to_listen:add(ag_down).
  // main loop
  local done is false.
  local old_selected_item is 0.
  local selected_item is 0.
  local ag_index is -1.
  until done
  {
    // print marker
    print " " at (0, old_selected_item + 2).
    print "*" at (0, selected_item + 2).
    set old_selected_item to selected_item.
    // main action
    set ag_index to wait_for_action_groups(ag_to_listen).
    if ag_index = ag_to_listen:length - 2 // up
    {
      set selected_item to max(0, selected_item - 1).
    }
    else if ag_index = ag_to_listen:length - 1 // down
    {
      set selected_item to min(list:length - 1, selected_item + 1).
    }
    else
    {
      set done to true.
    }
  }
  return list(ag_index, selected_item).
}
