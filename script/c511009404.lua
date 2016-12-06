--Performapal Sky Illusion
function c96457619.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511001069.condition)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_SPELLCASTER))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
		--cannot be battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c38026562.atlimit)
	c:RegisterEffect(e2)
	 --Self Destruct
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e3:SetCode(EVENT_PHASE+PHASE_END)
  e3:SetRange(LOCATION_SZONE)
  e3:SetOperation(c38026562.des_op)
  c:RegisterEffect(e3)
end
function c511001069.filter(c)
	return c:IsFaceup() and c:IsCode(93368494) and Duel.IsExistingMatchingCard(c511001069.filter,tp,LOCATION_MZONE,0,1,c)
end
function c511001069.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) 
end
function c511001069.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511001069.filter,tp,LOCATION_MZONE,0,1,nil)
end

function c38026562.atlimit(e,c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and not c:IsCode(511009393)
end

function c38026562.des_op(e,tp,eg,ep,ev,re,r,rp)
  Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end