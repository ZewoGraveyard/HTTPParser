// RawHTTPMethod.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Zewo
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

public enum RawHTTPMethod : Int {
    case DELETE      = 0
    case GET         = 1
    case HEAD        = 2
    case POST        = 3
    case PUT         = 4
    case CONNECT     = 5
    case OPTIONS     = 6
    case TRACE       = 7
    // WebDAV
    case COPY        = 8
    case LOCK        = 9
    case MKCOL       = 10
    case MOVE        = 11
    case PROPFIND    = 12
    case PROPPATCH   = 13
    case SEARCH      = 14
    case UNLOCK      = 15
    case BIND        = 16
    case REBIND      = 17
    case UNBIND      = 18
    case ACL         = 19
    // Subversion
    case REPORT      = 20
    case MKACTIVITY  = 21
    case CHECKOUT    = 22
    case MERGE       = 23
    // UPNP
    case MSEARCH     = 24
    case NOTIFY      = 25
    case SUBSCRIBE   = 26
    case UNSUBSCRIBE = 27
    // RFC-5789
    case PATCH       = 28
    case PURGE       = 29
    // CalDAV
    case MKCALENDAR  = 30
    
    case UNKNOWN     = 100
}
