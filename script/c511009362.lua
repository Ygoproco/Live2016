--Dark Contract with the Monopoly Seal
--fixed by MLD
function c511009362.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c511009362.sumlimit)
	c:RegisterEffect(e2)	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,1)
	e3:SetLabel(TYPE_FUSION)
	e3:SetCondition(c511009362.con)
	e3:SetTarget(c511009362.splimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetLabel(TYPE_SYNCHRO)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetLabel(TYPE_XYZ)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetLabel(TYPE_PENDULUM)
	c:RegisterEffect(e6)
end
function c511009362.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end
function c511009362.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and c:IsType(e:GetLabel())
end
function c511009362.filter(c,tpe)
	return c:IsFaceup() and c:IsType(tpe)
end
function c511009362.con(e)
	return Duel.IsExistingMatchingCard(c511009362.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,e:GetLabel())
end
