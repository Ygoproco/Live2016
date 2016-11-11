--Dark Contract with the Monopoly Seal
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
	e3:SetCondition(c511009362.fcondition)
	e3:SetTarget(c511009362.fsumlimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCondition(c511009362.scondition)
	e4:SetTarget(c511009362.ssumlimit)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCondition(c511009362.xcondition)
	e5:SetTarget(c511009362.xsumlimit)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCondition(c511009362.pcondition)
	e6:SetTarget(c511009362.psumlimit)
	c:RegisterEffect(e6)
end
function c511009362.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end
function c511009362.fsumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_FUSION)
end
function c511002016.fusfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function c511002016.fcondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511002016.fusfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c511009362.ssumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_SYNCHRO)
end
function c511002016.synfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c511002016.scondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511002016.synfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c511009362.Xsumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_XYZ)
end
function c511002016.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c511002016.xcondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511002016.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c511009362.psumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_PENDULUM)
end
function c511002016.penfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c511002016.pcondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511002016.penfilter,tp,LOCATION_MZONE,0,1,nil)
end