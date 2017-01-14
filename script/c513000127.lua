--Gjallarhorn
--scripted by Keddy
function c513000127.initial_effect(c)
	--Return
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c513000127.condition)
	e1:SetTarget(c513000127.target)
	e1:SetOperation(c513000127.activate)
	c:RegisterEffect(e1)
end
function c513000127.cfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_DEVINE)
end
function c513000127.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	return eg:IsExists(c513000127.cfilter,1,nil,tp)
end
function c513000127.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetLabelObject(e)
	e1:SetOperation(c513000127.resetop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	c:SetTurnCounter(0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetLabel(3)
	e2:SetCountLimit(1)
	e2:SetCondition(c513000127.remcon)
	e2:SetOperation(c513000127.remop)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,3)
	c:RegisterEffect(e2)
	e:GetHandler():RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,3)
	c513000127[c]=e2
end
function c513000127.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_DEVINE))
	Duel.RegisterEffect(e3,tp)
end
function c513000127.resetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetType(EFFECT_TYPE_QUICK_O)
end
function c513000127.remcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c513000127.remop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==3 then
		local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_REMOVE)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e2:SetCode(513000127)
		e2:SetCountLimit(1)
		e2:SetTarget(c513000127.damtg)
		e2:SetOperation(c513000127.damop)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		c:RegisterEffect(e2)
		c:ResetFlagEffect(1082946)
		Duel.RaiseSingleEvent(c,513000127,e,r,rp,ep,0)
	end
end
function c513000127.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetSum(Card.GetAttack))
end
function c513000127.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,nil)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)	
	Duel.Damage(1-tp,g:GetSum(Card.GetAttack),REASON_EFFECT)
end
