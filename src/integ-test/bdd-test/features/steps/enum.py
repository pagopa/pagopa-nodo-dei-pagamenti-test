from behave import register_type
from parse_type import TypeBuilder

parse_oldnew = TypeBuilder.make_enum({"old": "old", "new": "new"})
register_type(OldNew=parse_oldnew)

parse_ecpsp = TypeBuilder.make_enum({"ec": "ec", "psp": "psp"})
register_type(EcPsp=parse_ecpsp)

parse_method = TypeBuilder.make_enum({"get": "GET", "post": "POST"})
register_type(Method=parse_method)