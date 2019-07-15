'use strict'
###
esat
utilities

@author Saksham
@note Last Branch Update - master
     
@note Created on 2018-06-18 by Saksham
@note Updates :
  Saksham - 2019 07 15 - master - typeOf
###

exports.uuid = () ->
  s = []
  hexDigits = '0123456789abcdef'
  i = 0
  while i < 36
    s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1)
    i++
  s[14] = '4'
  # bits 12-15 of the time_hi_and_version field to 0010
  s[19] = hexDigits.substr(s[19] & 0x3 | 0x8, 1)
  # bits 6-7 of the clock_seq_hi_and_reserved to 01
  s[8] = s[13] = s[18] = s[23] = '-'
  uuid = s.join('')
  return uuid

exports.typeOf = (data) ->
  stringConstructor = 'test'.constructor
  arrayConstructor = [].constructor
  objectConstructor = {}.constructor
  if data == null
    "null"
  else if data == undefined
    "undefined"
  else if data.constructor == stringConstructor
    "string"
  else if data.constructor == arrayConstructor
    "array"
  else if data.constructor == objectConstructor
    "object"
  else if Number.isInteger(data)
    "number"
  else
    "unknown"