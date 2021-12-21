from behave import register_type
from parse_type import TypeBuilder

parse_oldnew = TypeBuilder.make_enum({"Old": "old", "New": "new"})
register_type(OldNew=parse_oldnew)

parse_ecpsp = TypeBuilder.make_enum({"Ec": "ec", "Psp": "psp"})
register_type(EcPsp=parse_ecpsp)