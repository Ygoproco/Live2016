--Space Jump
function c511000875.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c511000875.condition)
	e1:SetTarget(c511000875.target)
	e1:SetOperation(c511000875.activate)
	c:RegisterEffect(e1)
end
function c511000875.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	local ex,dg=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local ex2,dg2=Duel.GetOperationInfo(0,CATEGORY_REMOVE)
	e:SetLabelObject(tc)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE 
		and tc:IsControler(tp) and tc:IsType(TYPE_MONSTER) 
		and ((dg and dg:GetCount()==1 and dg:GetFirst()==tc) or (dg2 and dg2:GetCount()==1 and dg2:GetFirst()==tc))
end
function c511000875.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return tc:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,tc:GetAttack())
end
function c511000875.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:IsFaceup() then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)
	end
end
