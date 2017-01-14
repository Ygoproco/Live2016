--ＴＧ ドリル・フィッシュ
function c100000245.initial_effect(c)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(c100000245.dircon)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c100000245.descon)
	e2:SetTarget(c100000245.destg)
	e2:SetOperation(c100000245.desop)
	c:RegisterEffect(e2)
end
function c100000245.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x27)
end
function c100000245.dircon(e)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c100000245.spfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c100000245.descon(e,tp,eg,ep,ev,re,r,rp,chk)
	return ep~=tp and Duel.GetAttackTarget()==nil
end
function c100000245.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c100000245.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end